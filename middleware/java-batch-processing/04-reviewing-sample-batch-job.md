Our sample application [intro-jberet](https://github.com/jberet/intro-jberet)
demonstrates basic concepts and programming model in batch processing, such as
job, step (batchlet- and chunk-type steps), batch properties, item reader and writer.

The job structure and flow are defined in the job XML file 
[csv2db](https://github.com/jberet/intro-jberet/blob/master/src/main/resources/META-INF/batch-jobs/csv2db.xml).
It contains 2 steps:

* ``csv2db.step1``: a batchlet-type step, which performs a specific task: initializing table ``MOVIES``.

```xml
<step id="csv2db.step1" next="csv2db.step2">
  <batchlet ref="jdbcBatchlet">
    <properties>
      <property name="url" value=
        "jdbc:postgresql://#{jobParameters['db.host']}?:postgresql;/#{jobParameters['db.name']}?:sampledb;"/>
        
        <property name="user" value=
          "#{jobParameters['db.user']}?:jberet;"/>
        
        <property name="password" value=
          "#{jobParameters['db.password']}?:jberet;"/>

        <property name="sqls" value="
          CREATE TABLE IF NOT EXISTS MOVIES (
          rank INTEGER NOT NULL PRIMARY KEY,
          tit  VARCHAR(128),
          grs  NUMERIC(12, 3),
          opn  DATE);
          DELETE FROM MOVIES"/>
    </properties>
  </batchlet>
</step>
```

* ``csv2db.step2``: a chunk-type step, which reads, processes and writes data in chunks, and repeats the 
read-process-write cycle till the input is exhausted. 
                    
```xml
<!-- read data from online CSV resource and output
  to db, following chunk processing pattern -->
     
<step id="csv2db.step2">
  <chunk>
    <reader ref="csvItemReader">
      <properties>
      <property name="resource" value=
        "https://raw.githubusercontent.com/jberet/jsr352/master/jberet-support/src/test/resources/movies-2012.csv"/>
        
      <property name="beanType" value=
        "java.util.Map"/>
        
      <property name="nameMapping" value=
        "rank,tit,grs,opn"/>
        
      <property name="cellProcessors" value= 
        "ParseInt; 
        NotNull, StrMinMax(1, 100); 
        DMinMax(1000000, 1000000000); 
        ParseDate('yyyy-MM-dd')"/>
      </properties>
    </reader>
        
    <!-- processor is optional and is not used -->

    <writer ref="jdbcItemWriter">
      <properties>
      <!-- url, user & password properties are the same 
        as in csv2db.step1, and are now shown here -->

      <property name="sql" value=
        "insert into MOVIES (rank,tit,grs,opn) 
                     VALUES (?, ?, ?, ?)"/>
        
      <property name="parameterNames" value=
        "rank,tit,grs,opn"/>
          
      <property name="parameterTypes" value=
        "Int,String,Double,Date"/>
          
      <property name="beanType" value=
        "java.util.Map"/>
      </properties>
    </writer>
  </chunk>
</step>
```

In ``csv2db`` job, 3 batch artifacts from ``jberet-support`` library are used to implement the processing logic:

* ``jdbcBatchlet``: executes SQL statements against target db.
* ``csvItemReader``: reads from CSV input source, one line at a time.
* ``jdbcItemWriter``: writes accumulated data in a chunk to target db.

As you can see from the above job definition, batch artifacts can be configured with batch properties to
customize their behavior. Furthermore, batch properties can reference system properties, other job properties,
and job parameters. Default value can also be supplied as part of batch property expression.