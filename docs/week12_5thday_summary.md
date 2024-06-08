## DBT  
  
### 개념 요약  

1. dbt (Data Build Tool)  
  - ELT를 보다 용이하게 사용할 수 있도록 만든 오픈 소스로, 다양한 데이터 웨어하우스를 지원함
    - BigQuery, Redshift, Snowflake, Spark(Hive 연동)
  - 구성 요소로 models, tests, snapshots로 구성됨
2. dbt Seeds  
  - dimension 테이블은 규모가 작고, 데이터가 많이 변하지 않으므로, 작은 csv 파일 자체를 D/W로 로드하는 방법  
  - 프로젝트 디렉터리 내 seeds 폴더 내 csv 파일을 넣고 ```dbt seed``` 명령어를 통해 실행  
3. dbt Sources  
  - 처음 입력 테이블에 별칭을 주고, 이 별칭을 staging 테이블에서 사용  
    - 이는 입력 테이블이 계속 바뀌면 sql 파일 내 하나씩 찾아 바꿔줘야 하는 번거로움을 해소하고자 나타난 것임  
  - 프로젝트 디렉터리에서 models 디렉터리 내 sources.yml 파일을 생성하고, 파일 내용을 기반으로 sql 내용을 jinja 템플릿을 활용 변경  
    - ```{{ source("yonggu_choi", "event") }}```  
  - 추가로, 데이터의 Freshness 를 확인 가능 \(sources.yml 파일 내 다음 내용 추가, ```dbt source fressness``` 명령 수행\)
    ```
      loaded_at_field: datestamp
      fressness:
        warn_after: { count: 1, period: hour }
        error_after: { count: 24, period: hour }
    ```
4. dbt Snapshots  
  - 테이블의 변화를 지속적으로 기록 → 해당 시점으로 롤백하여 내용을 볼 수 있는 기능  
  - snapshots 디렉터리 내 관련 기능을 구현하는 config를 포함한 쿼리 파일이 있어야 함  
    - 또한, 해당 기록을 하기 위한 조건(pk, ts column) 필요  
  - 실행은 ```dbt snapshot``` 명령을 통해 실행 가능  
    - 유의사항으로 프로젝트 루트 폴더에서 해당 명령을 실행할 것!  
5. dbt Tests  
  - 데이터 품질을 테스트하는 방법으로, 내장 일반 테스트와 커스텀 테스트 방법이 존재함  
  - 내장 일반 테스트는 프로젝트의 models 디렉터리 내 schema.yml 파일에 정의  
  - 커스텀 테스트는 프로젝트의 test 디렉터리 내 테스트를 위한 쿼리문 작성  
    - 이 테스트 결과 Rows가 나오면 안 됨  
  - 테스트는 ```dbt test``` 명령을 통해 수행 가능  
    - [추가 옵션](https://docs.getdbt.com/reference/commands/test)을 통해 특정 테이블 대상으로 테스트가 가능하며 테스트 간 [디버깅](https://docs.getdbt.com/reference/commands/debug)이 가능함  
6. dbt Documentation  
  - yml 파일 내 문서화에 필요한 내용 작성하거나 별도 markdown 파일을 작성하는 방법을 통해 문서화 가능  
  - 작성 내용 기반 ```dbt doc generate``` 명령을 통해 프로젝트의 target 디렉터리 내 catalog.json 파일 생성  
  - 이후, ```dbt docs serve``` 명령을 통해 경량 웹서버를 통해 내용 확인 가능 (테이블 계보(lineage)를 시각화해서 보여줌)  
7. dbt Expectations  
  - pandas, spark에서 사용 가능한 [Great Expectations](https://docs.greatexpectations.io/docs/reference/learn/conceptual_guides/gx_overview)를 dbt에서 사용할 수 있도록 구현한 dbt 확장판임
  - dbt 제공 테스트와 같이 사용  
    - 기본 제공 테스트보다 더 많은 함수(약 3~40개)를 제공하여 데이터 유효성 체크가 가능  
