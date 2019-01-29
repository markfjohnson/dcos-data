from cassandra.cluster import Cluster
from cassandra import ConsistencyLevel
from cassandra.query import *

from pyspark import SparkContext, SparkConf, SQLContext
from pyspark.sql import SparkSession
from pyspark import SparkConf
from pyspark.sql import SQLContext



KEYSPACE="Financial"
#import_file = "https://s3.amazonaws.com/mark-johnson/CCL.csv"
import_file = "s3a://mark-johnson/CCL.csv"

sc = SparkContext(appName="PySpark Cassandra File Write Example")


spark = SparkSession.builder \
    .appName("PySpark Cassandra File Write Example") \
    .config("spark.sql.crossJoin.enabled", "true") \
    .getOrCreate()



cluster = Cluster(['node-0.cassandra.mesos'])  # provide contact points and port

# Verify Tables and Keyspaces exist for data if not then create it
session = cluster.connect()

#session.execute("""
#     CREATE KEYSPACE %s
#     WITH replication = { 'class': 'SimpleStrategy', 'replication_factor': '2' }
#     """ % KEYSPACE)

session.execute("""
    USE financial;
""")

#session.execute("""
#      CREATE TABLE stock_prices (
#        transDate timestamp,
#        openPrice float,
#        high float,
#        low float,
#        closePrice float,
#        adj_price FLOAT,
#        volume int,
#          PRIMARY KEY (transDate)
#      )
#      """)


lines = sc.textFile(import_file)
print(lines.count())


#df = spark.read.csv(import_file, header=True)
#print(df.head())
#myList = df.collect()
#print (myList)






# Run the batch to read a block of input file rows and then prepare a cassandra write batch

insert_stock = session.prepare("INSERT INTO users (transDate,openPrice, high,low,closePrice, adj_price, volume) VALUES (?, ?, ?, ?, ?, ?, ?)")
batch = BatchStatement(consistency_level=ConsistencyLevel.QUORUM)

for (name, age) in users_to_insert:
    batch.add(insert_user, (name, age))

session.execute(batch)

#rows = session.execute('select * from table limit 5;')
#for row in rows:
#    print row.id