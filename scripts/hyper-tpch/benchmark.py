import os
import re
import sys
import tempfile
import time
from pathlib import Path

from jsonlines import jsonlines

class Hyper:
    def __init__(self):
        from tableauhyperapi import HyperProcess, Telemetry, Connection, CreateMode
        self.path = "/hyper-script"
        self.result = None
        self.hyperDir = tempfile.TemporaryDirectory(dir="/hyper-script")

        self.hyperDB = Path(os.path.join(self.hyperDir.name, 'test.hyper'))
        os.makedirs(os.path.dirname(self.hyperDB), exist_ok=True)

        os.chdir(sys.argv[1])

        parameters = {"log_dir": self.hyperDir.name, "hard_concurrent_query_thread_limit": "1"}
        self.hyper = HyperProcess(telemetry=Telemetry.DO_NOT_SEND_USAGE_DATA_TO_TABLEAU, parameters=parameters)
        self.connection = Connection(endpoint=self.hyper.endpoint, database=self.hyperDB, create_mode=CreateMode.CREATE_AND_REPLACE)

        schema = os.path.join(self.path, "data/schema.sql")
        for table in open(schema, "r").read().split(";"):
            table = re.sub(r',\s*\n\s*primary key\s*\([^)]*\)', "", table.lower().strip())
            table = re.sub(r',\s*\n\s*foreign key\s*\([^)]*\)\s*references[^(]*\([^)]*\)', "", table)
            table = re.sub(r'primary key', "", table)
            self.connection.execute_query(query=table.strip()).close()

        tables = os.path.join(self.path, "data/load.sql")
        for table in open(tables, "r").read().split(";"):
            self.connection.execute_query(query=table.strip()).close()

    def close(self):
        self.hyperDB.unlink()
        self.hyper.close()
        self.connection.close()
        self.hyperDir.cleanup()

    def evaluateQuery(self, query):
        self.result = self.connection.execute_query(query=query.strip())


    def getDataTypes(self):
        return "tsv"
    def showResults(self):
        from tableauhyperapi import TypeTag
        for row in self.result:
            tuple = ()
            for (i, column) in enumerate(row):
                type = self.result.schema.columns[i].type
                if column is None:
                    tuple += ("NULL",)
                elif type.tag == TypeTag.CHAR:
                    tuple += (str(column).rstrip().ljust(type.max_length),)
                elif type.tag == TypeTag.VARCHAR or type.tag == TypeTag.TEXT:
                    tuple += (column,)
                else:
                    tuple += (str(column),)
            #print("\t".join(tuple) + "\n")
        time.sleep(1)

        self.result.close()
    def analyze(self):
        with jsonlines.open(self.hyperDir.name+'/hyperd.log') as reader:
            q = 1
            t =1
            print("query  run   time     hypercompile")
            for obj in reader:
                if obj['k'] == 'query-end' and obj['v']['statement'] == 'SELECT':
                    comp_time= obj['v']['initial-compilation-time']
                    if 'adaptive-compilation' in obj['v']:
                        comp_time+=obj['v']['adaptive-compilation']['compilation-time']
                    print(q, t, obj['v']['execution-time'] * 1000,
                          comp_time * 1000)
                    if t==5:
                        t=1
                        q+=1
                    else:
                        t+=1

hyper=Hyper()
for qnum in range(1, 23):
    file1 = "/tpch-queries/" + str(qnum) + ".sql"
    with open(file1, 'r') as file:
        query = file.read()
        for i in range(0,5):
            hyper.evaluateQuery(query)
            hyper.showResults()
hyper.analyze()
hyper.close()