<h1 align="center"> 👋 오래된 AWS IAM Access Key 검출하기 </h1>
<p>
  <a href="https://sed-gitlab.hanpda.com/jhjeong/test/blob/master/README.md">
    <img src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  </a>
  <a href="https://sed-gitlab.hanpda.com/jhjeong/test/blob/master/README.md">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" target="_blank" />
  </a>
</p>

## 요구사항
> 아래를 만족하는 어플리케이션을 구현합니다.
- `Access Key Pair`가 생성 후 N시간을 초과하는 `IAM User`를 찾아 임의의 `file`에 출력
- `File`에 출력하는 정보에는 아래 내용을 포함
  - 해당 `IAM User`의 `User name`
  - 해당 `IAM User`의 `"AKIA"` 로 시작하는 `Access Key ID`
  - 해당 `Access Key`의 생성 시간
- 임의의 기간 `N시간`은 `파라미터`로 전달
- `파라미터`는 환경변수(Environment Variable), CLI 파라미터, 설정 파일, URL query string 등 방식을 선택하여 어플리케이션 `외부`에서 입력
- 어플리케이션은 아래 중 하나를 만족하여 동작
  - `1회 동작` 후 종료 (CLI 도구 처럼 1회만 동작)
  - HTTP 통신 기반의 API를 작성하고, `API 호출`을 통하여 상시 동작 (Web Service 동작 방식)
- 어플리케이션이 `Minikube환경` (혹은 일반 `Kubernetes` 환경)에서 동작할 수 있는 `Manifest`를 포함
- 요구사항을 만족하는 소스코드를 `github.com`에 공개하여 제출

## 개요
> `Minikube` 클러스터 환경에서 IaC 도구인 `Terraform`을 이용하여 쿠버네티스 리소스를 자동화 하여 쉽고 빠르게 프로비저닝 합니다. 그리고, `Job(Pod)`에서 구동하는 컨테이너의 외부에서 파라미터를 전달받아서 스크립트를 실행한 후에 결과값을 출력 후 파일로 저장하고 `Complete` 된 Pod는 삭제됩니다.

> 위의 `Job(Pod)`에서 `1회성` 작업이 아닌 경우, 즉 `반복적`으로 스케줄링 되어야 할 경우에는 `CronJob(Pod)`를 사용하여 주기적으로 컨테이너 실행후에 결과값을 출력하고 파일로 저장합니다.
![image](https://user-images.githubusercontent.com/31501015/156632671-e4081d6c-7874-4cad-a5f9-2b7814587016.png)

## 환경
> 버전 정보
```sh
- Terraform : v1.1.6
- Minikube : v1.25.2
- Kubelet : v1.23.3
- Kubernetes : v1.23.3
- Docker : v20.10.12 (Container Runtime)
```
> 디렉토리 레이아웃
```sh
- docker  # zepplin 설정 파일이 있는 디렉토리
  ㄴ Dockerfile # 이미지 빌드를 위한 DockerFile
  ㄴ aws_iam_detect.sh # 컨테이너에서 실행되는 스크립트
- README.md  # README 문서
- probider.tf  # 프로바이더 파일
- version.tf # 버전 파일
- variables.tf # 입력 변수 파일
- outputs.tf # 출력 변수 파일
- terraform.tfvars # 동적 변수 파일
- k8s_job.tf # Kubernetes Job 매니페스트 파일
- k8s_cronjob.tf # Kubernetes CronJob 매니페스트 파일
- k8s_configmap.tf # Kubernetes Configmap 매니페스트 파일
- k8s_namespace.tf # Kubernetes Namespace 매니페스트 파일
```
## 준비
> 사용자 터미널에서 Minikube 클러스터 시작
```bash
$ minikube start
* Microsoft Windows 10 Home 10.0.19043 Build 19043 의 minikube v1.25.2
* 기존 프로필에 기반하여 docker 드라이버를 사용하는 중
* minikube 클러스터의 minikube 컨트롤 플레인 노드를 시작하는 중
* 베이스 이미지를 다운받는 중 ...
* Restarting existing docker container for "minikube" ...
* 쿠버네티스 v1.23.3 을 Docker 20.10.12 런타임으로 설치하는 중
  - kubelet.housekeeping-interval=5m
* Kubernetes 구성 요소를 확인...
  - Using image gcr.io/k8s-minikube/storage-provisioner:v5
* 애드온 활성화 : storage-provisioner, default-storageclass
* 끝났습니다! kubectl이 "minikube" 클러스터와 "default" 네임스페이스를 기본적으로 사용하도록 구성되었습니다.
```
> 사용자 터미널에서 `AWS Credential` 정보를 환경 변수로 설정
```sh
$ export TF_VAR_aws_access_key=<AWS Access Key ID>
$ export TF_VAR_aws_secret_key=<AWS Secret Access KEY>
```
> 현재 아래 입력 변수 파일 `variables.tf`에서 Region은 한국 리전을 기본으로 사용
```sh
////////////////////////
/// Common Variables
///////////////////////
name    = "task"  # k8s 오브젝트에서 사용할 이름에 대한 변수
region  = "ap-northeast-2" # k8s Configmap에서 사용 할 리전 정보 
#profile = "musinsa" # Terraform에서 사용 할 AWS Credential 프로파일 지정 (생략 가능)

////////////////////////
///   k8s Variables
///////////////////////
k8s_namespace         = "task-nm" # k8s 네임스페이스 이름 변수
create_k8s_job        = true # k8s job 오브젝트 생성유무 (true: 생성, false: 미생성)
create_k8s_cronjob    = true # k8s Cronjob 오브젝트 생성유무 (true: 생성, false: 미생성)
accesskey_unreplaced_day = "200" # AccessKey 생성 후 교체되지 않은 일(day)에 대한 변수로  환경 변수, 파라미터에서 참조하는 변수
```
## 사용법
### *Terraform 사용법*
```sh
# `Terraform init` 명령은 provider에 맞는 플러그인을 다운로드 합니다.
terraform init

# `Terraform plan` 명령은 코드와 AWS 인프라 상태를 비교하여 생성/변경/삭제 사항들을 나열 합니다. (Dry run Test)
terraform plan

# `Terraform apply` 명령은 위의 생성/변경/삭제 사항들을 AWS 인프라 리소르를 프로비저닝 합니다.
terraform apply

# `Terraform destroy` 명령은 프로비저닝 된 AWS 인프라 리소스를 제거 합니다.
terraform destroy
```

### *Terraform 실행*
> 사용자 터미널에서 소스 코드를 내려받은 후에 Terraform apply로 k8s 리소스 프로비저닝
```sh
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # kubernetes_config_map.task-configmap will be created
  + resource "kubernetes_config_map" "task-configmap" {
    ...
    }
      + id   = (known after apply)
      + metadata {
          + generation       = (known after apply)
          + name             = "task-configmap"
          + namespace        = "task-nm"
        }
    }

  # kubernetes_cron_job_v1.task-cronjob[0] will be created
  + resource "kubernetes_cron_job_v1" "task-cronjob" {
      + id = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = "task-cronjob"
          + namespace        = "task-nm"
        }
    ...
  # kubernetes_job.task-job[0] will be created
  + resource "kubernetes_job" "task-job" {
      + id                  = (known after apply)
      + wait_for_completion = true
      + metadata {
          + generation       = (known after apply)
          + labels           = (known after apply)
          + name             = "task-job"
          + namespace        = "task-nm"
        }
  ...
  # kubernetes_namespace.task-namespace will be created
  + resource "kubernetes_namespace" "task-namespace" {
      + id = (known after apply)
      + metadata {
          + generation       = (known after apply)
          + labels           = {
              + "mylabel" = "task"
            }
          + name             = "task-nm"
        }
    }
Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.
  Enter a value: yes

kubernetes_config_map.task-configmap: Creating...
kubernetes_namespace.task-namespace: Creating...
kubernetes_namespace.task-namespace: Creation complete after 0s [id=task-nm]
kubernetes_config_map.task-configmap: Creation complete after 0s [id=task-nm/task-configmap]
kubernetes_job.task-job[0]: Creating...
kubernetes_cron_job_v1.task-cronjob[0]: Creating...
kubernetes_cron_job_v1.task-cronjob[0]: Creation complete after 0s [id=task-nm/task-cronjob]
kubernetes_job.task-job[0]: Still creating... [10s elapsed]
kubernetes_job.task-job[0]: Still creating... [20s elapsed]
kubernetes_job.task-job[0]: Still creating... [30s elapsed]
kubernetes_job.task-job[0]: Creation complete after 36s [id=task-nm/task-job]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
### *Terraform 실행 예제*
> `IAM User`중에 `Access Key Pair`를 소유하면서 `150일` 이후로 교체하지 않은 `IAM User`를 찾아내어 출력합니다.
1. `terraform.tfvars` 파일을 열어서 변수를 설정 합니다. 여기에서 `accesskey_unused_days`변수는 150일(day)에 대한 값을 지정합니다. 
    ```sh
    ////////////////////////
    ///   k8s Variables
    ///////////////////////
    k8s_namespace         = "task-nm" # k8s 네임스페이스 이름 변수
    create_k8s_job        = true # k8s job 오브젝트 생성유무 (true: 생성, false: 미생성)
    create_k8s_cronjob    = true # k8s Cronjob 오브젝트 생성유무 (true: 생성, false: 미생성)
    accesskey_unreplaced_day = "150" # AccessKey 생성 후 교체되지 않은 일(day)에 대한 변수
    ```
2. 위의 `terraform.tfvars` 파일 수정후 `terraform plan`으로 실행 계획을 확인한 후 `terraform apply` 으로 리소스 프로비저닝합니다.
    ```sh
    $ terraform apply

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      + create
    Terraform will perform the following actions:

      # kubernetes_config_map.task-configmap will be created
      + resource "kubernetes_config_map" "task-configmap" {
          + data = {
              + "AWS_ACCESS_KEY_ID"     = (sensitive)  # 민감 정보에 대해 Sensitive 플래그를 설정하여 노출 위험 감소
              + "AWS_DEFAULT_REGION"    = "ap-northeast-2"
              + "AWS_SECRET_ACCESS_KEY" = (sensitive) # 민감 정보에 대해 Sensitive 플래그를 설정하여 노출 위험 감소
              + "DAYS"                  = "200"
            }
          + id   = (known after apply)
          + metadata {
              + generation       = (known after apply)
              + name             = "task-configmap"
              + namespace        = "task-nm"
              + resource_version = (known after apply)
              + uid              = (known after apply)
            }
        }
    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

      Enter a value: yes

    kubernetes_config_map.task-configmap: Creating...
    kubernetes_namespace.task-namespace: Creating...
    kubernetes_namespace.task-namespace: Creation complete after 0s [id=task-nm]
    kubernetes_config_map.task-configmap: Creation complete after 0s [id=task-nm/task-configmap]
    kubernetes_job.task-job[0]: Creating...
    kubernetes_cron_job_v1.task-cronjob[0]: Creating...
    kubernetes_cron_job_v1.task-cronjob[0]: Creation complete after 0s [id=task-nm/task-cronjob]
    kubernetes_job.task-job[0]: Still creating... [10s elapsed]
    kubernetes_job.task-job[0]: Still creating... [20s elapsed]
    kubernetes_job.task-job[0]: Still creating... [30s elapsed]
    kubernetes_job.task-job[0]: Creation complete after 36s [id=task-nm/task-job]

    Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
    ```
3. `kubectl`에서 생성된 Job 오브젝트 실행되어 Pod가 실행되고 정상적으로 작업을 마친 후에는 `Completed` 상태로 종료됩니다. Pod가 실행될때 Pull로 내려받는 컨테이너 Image에는 `aws_iam_detect.sh` 스크립트, Python, awscli등을 포함하고 있습니다.
    * *컨테이너 이미지* : https://hub.docker.com/repository/docker/sepiros62/alpine_awscli/general 
    ```sh
    $ kubectl get job -n task-nm
    NAME       COMPLETIONS   DURATION   AGE
    task-job   1/1           28s        106s

    $ kubectl get pod -n task-nm
    NAME             READY   STATUS      RESTARTS   AGE
    task-job-4mwjl   0/1     Completed   0          112s
    ```

4. `minikube` 클러스터 노드에서 호스트 경로(HostPath)를 볼륨으로 사용하여 `/tmp/task-volume/final_list_날짜.csv` 파일로 실행 결과를 저장합니다. 아래 실행 결과는 AccessKey를 생성하고 `150일` 이상 교체하지 않은 `IAM UserName`, `AccessKeyId`, `CreateDate`에 대한 내용을 포함하는 `IAM USER`를 저장합니다.
    ```sh
    root@minikube:/tmp/task-volume# cat final_list_20220228.csv
    chloe.kim AKIAQWOA54DN4EL3ZEH3 2021-06-14 259
    hojin.shim AKIAQWOA54DN3MZFIGAW 2021-06-14 259
    hojin.shim AKIAQWOA54DN73DDKCGO 2021-06-14 259
    jonny.koo AKIAQWOA54DNZDSM3567 2021-06-14 259
    Test2 AKIAQWOA54DNWXCHCP4F 2021-06-15 258
    Test4 AKIAQWOA54DNXQT2NJFI 2021-06-15 258
    Test5 AKIAQWOA54DNYJZPZJOG 2021-06-15 258
    Test6 AKIAQWOA54DN5RS5JBU3 2021-06-15 258
    Test7 AKIAQWOA54DNUWEHM5J7 2021-06-15 258
    Test8 AKIAQWOA54DNRZU2JB5O 2021-06-15 258
    youngwoo.kim AKIAQWOA54DN6CXFLIDV 2021-06-15 258
    ```

## 실행 결과
> Kubernetes IDE 툴인 `Lens`에서의 Job 실행 결과에 대한 로그 내용 확인

![image](https://user-images.githubusercontent.com/31501015/155955369-e27742f0-3d3e-4e31-be18-2f93ce3ab2c5.png)
