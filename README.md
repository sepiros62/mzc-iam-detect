<h1 align="center"> π μ€λλ AWS IAM Access Key κ²μΆνκΈ° </h1>
<p>
  <a href="https://sed-gitlab.hanpda.com/jhjeong/test/blob/master/README.md">
    <img src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  </a>
  <a href="https://sed-gitlab.hanpda.com/jhjeong/test/blob/master/README.md">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" target="_blank" />
  </a>
</p>

## μκ΅¬μ¬ν­
> μλλ₯Ό λ§μ‘±νλ μ΄νλ¦¬μΌμ΄μμ κ΅¬νν©λλ€.
- `Access Key Pair`κ° μμ± ν Nμκ°μ μ΄κ³Όνλ `IAM User`λ₯Ό μ°Ύμ μμμ `file`μ μΆλ ₯
- `File`μ μΆλ ₯νλ μ λ³΄μλ μλ λ΄μ©μ ν¬ν¨
  - ν΄λΉ `IAM User`μ `User name`
  - ν΄λΉ `IAM User`μ `"AKIA"` λ‘ μμνλ `Access Key ID`
  - ν΄λΉ `Access Key`μ μμ± μκ°
- μμμ κΈ°κ° `Nμκ°`μ `νλΌλ―Έν°`λ‘ μ λ¬
- `νλΌλ―Έν°`λ νκ²½λ³μ(Environment Variable), CLI νλΌλ―Έν°, μ€μ  νμΌ, URL query string λ± λ°©μμ μ ννμ¬ μ΄νλ¦¬μΌμ΄μ `μΈλΆ`μμ μλ ₯
- μ΄νλ¦¬μΌμ΄μμ μλ μ€ νλλ₯Ό λ§μ‘±νμ¬ λμ
  - `1ν λμ` ν μ’λ£ (CLI λκ΅¬ μ²λΌ 1νλ§ λμ)
  - HTTP ν΅μ  κΈ°λ°μ APIλ₯Ό μμ±νκ³ , `API νΈμΆ`μ ν΅νμ¬ μμ λμ (Web Service λμ λ°©μ)
- μ΄νλ¦¬μΌμ΄μμ΄ `Minikubeνκ²½` (νΉμ μΌλ° `Kubernetes` νκ²½)μμ λμν  μ μλ `Manifest`λ₯Ό ν¬ν¨
- μκ΅¬μ¬ν­μ λ§μ‘±νλ μμ€μ½λλ₯Ό `github.com`μ κ³΅κ°νμ¬ μ μΆ

## κ°μ
> `Minikube` ν΄λ¬μ€ν° νκ²½μμ IaC λκ΅¬μΈ `Terraform`μ μ΄μ©νμ¬ μΏ λ²λ€ν°μ€ λ¦¬μμ€λ₯Ό μλν νμ¬ μ½κ³  λΉ λ₯΄κ² νλ‘λΉμ λ ν©λλ€. κ·Έλ¦¬κ³ , `Job(Pod)`μμ κ΅¬λνλ μ»¨νμ΄λμ μΈλΆμμ νλΌλ―Έν°λ₯Ό μ λ¬λ°μμ μ€ν¬λ¦½νΈλ₯Ό μ€νν νμ κ²°κ³Όκ°μ μΆλ ₯ ν νμΌλ‘ μ μ₯νκ³  `Complete` λ Podλ μ­μ λ©λλ€.

> μμ `Job(Pod)`μμ `1νμ±` μμμ΄ μλ κ²½μ°, μ¦ `λ°λ³΅μ `μΌλ‘ μ€μΌμ€λ§ λμ΄μΌ ν  κ²½μ°μλ `CronJob(Pod)`λ₯Ό μ¬μ©νμ¬ μ£ΌκΈ°μ μΌλ‘ μ»¨νμ΄λ μ€ννμ κ²°κ³Όκ°μ μΆλ ₯νκ³  νμΌλ‘ μ μ₯ν©λλ€.
![image](https://user-images.githubusercontent.com/31501015/156632671-e4081d6c-7874-4cad-a5f9-2b7814587016.png)

## νκ²½
> λ²μ  μ λ³΄
```sh
- Terraform : v1.1.6
- Minikube : v1.25.2
- Kubelet : v1.23.3
- Kubernetes : v1.23.3
- Docker : v20.10.12 (Container Runtime)
```
> λλ ν λ¦¬ λ μ΄μμ
```sh
- docker  # zepplin μ€μ  νμΌμ΄ μλ λλ ν λ¦¬
  γ΄ Dockerfile # μ΄λ―Έμ§ λΉλλ₯Ό μν DockerFile
  γ΄ aws_iam_detect.sh # μ»¨νμ΄λμμ μ€νλλ μ€ν¬λ¦½νΈ
- README.md  # README λ¬Έμ
- probider.tf  # νλ‘λ°μ΄λ νμΌ
- version.tf # λ²μ  νμΌ
- variables.tf # μλ ₯ λ³μ νμΌ
- outputs.tf # μΆλ ₯ λ³μ νμΌ
- terraform.tfvars # λμ  λ³μ νμΌ
- k8s_job.tf # Kubernetes Job λ§€λνμ€νΈ νμΌ
- k8s_cronjob.tf # Kubernetes CronJob λ§€λνμ€νΈ νμΌ
- k8s_configmap.tf # Kubernetes Configmap λ§€λνμ€νΈ νμΌ
- k8s_namespace.tf # Kubernetes Namespace λ§€λνμ€νΈ νμΌ
```
## μ€λΉ
> μ¬μ©μ ν°λ―Έλμμ Minikube ν΄λ¬μ€ν° μμ
```bash
$ minikube start
* Microsoft Windows 10 Home 10.0.19043 Build 19043 μ minikube v1.25.2
* κΈ°μ‘΄ νλ‘νμ κΈ°λ°νμ¬ docker λλΌμ΄λ²λ₯Ό μ¬μ©νλ μ€
* minikube ν΄λ¬μ€ν°μ minikube μ»¨νΈλ‘€ νλ μΈ λΈλλ₯Ό μμνλ μ€
* λ² μ΄μ€ μ΄λ―Έμ§λ₯Ό λ€μ΄λ°λ μ€ ...
* Restarting existing docker container for "minikube" ...
* μΏ λ²λ€ν°μ€ v1.23.3 μ Docker 20.10.12 λ°νμμΌλ‘ μ€μΉνλ μ€
  - kubelet.housekeeping-interval=5m
* Kubernetes κ΅¬μ± μμλ₯Ό νμΈ...
  - Using image gcr.io/k8s-minikube/storage-provisioner:v5
* μ λμ¨ νμ±ν : storage-provisioner, default-storageclass
* λλ¬μ΅λλ€! kubectlμ΄ "minikube" ν΄λ¬μ€ν°μ "default" λ€μμ€νμ΄μ€λ₯Ό κΈ°λ³Έμ μΌλ‘ μ¬μ©νλλ‘ κ΅¬μ±λμμ΅λλ€.
```
> μ¬μ©μ ν°λ―Έλμμ `AWS Credential` μ λ³΄λ₯Ό νκ²½ λ³μλ‘ μ€μ 
```sh
$ export TF_VAR_aws_access_key=<AWS Access Key ID>
$ export TF_VAR_aws_secret_key=<AWS Secret Access KEY>
```
> νμ¬ μλ μλ ₯ λ³μ νμΌ `variables.tf`μμ Regionμ νκ΅­ λ¦¬μ μ κΈ°λ³ΈμΌλ‘ μ¬μ©
```sh
////////////////////////
/// Common Variables
///////////////////////
name    = "task"  # k8s μ€λΈμ νΈμμ μ¬μ©ν  μ΄λ¦μ λν λ³μ
region  = "ap-northeast-2" # k8s Configmapμμ μ¬μ© ν  λ¦¬μ  μ λ³΄ 
#profile = "musinsa" # Terraformμμ μ¬μ© ν  AWS Credential νλ‘νμΌ μ§μ  (μλ΅ κ°λ₯)

////////////////////////
///   k8s Variables
///////////////////////
k8s_namespace         = "task-nm" # k8s λ€μμ€νμ΄μ€ μ΄λ¦ λ³μ
create_k8s_job        = true # k8s job μ€λΈμ νΈ μμ±μ λ¬΄ (true: μμ±, false: λ―Έμμ±)
create_k8s_cronjob    = true # k8s Cronjob μ€λΈμ νΈ μμ±μ λ¬΄ (true: μμ±, false: λ―Έμμ±)
accesskey_unreplaced_day = "200" # AccessKey μμ± ν κ΅μ²΄λμ§ μμ μΌ(day)μ λν λ³μλ‘  νκ²½ λ³μ, νλΌλ―Έν°μμ μ°Έμ‘°νλ λ³μ
```
## μ¬μ©λ²
### *Terraform μ¬μ©λ²*
```sh
# `Terraform init` λͺλ Ήμ providerμ λ§λ νλ¬κ·ΈμΈμ λ€μ΄λ‘λ ν©λλ€.
terraform init

# `Terraform plan` λͺλ Ήμ μ½λμ AWS μΈνλΌ μνλ₯Ό λΉκ΅νμ¬ μμ±/λ³κ²½/μ­μ  μ¬ν­λ€μ λμ΄ ν©λλ€. (Dry run Test)
terraform plan

# `Terraform apply` λͺλ Ήμ μμ μμ±/λ³κ²½/μ­μ  μ¬ν­λ€μ AWS μΈνλΌ λ¦¬μλ₯΄λ₯Ό νλ‘λΉμ λ ν©λλ€.
terraform apply

# `Terraform destroy` λͺλ Ήμ νλ‘λΉμ λ λ AWS μΈνλΌ λ¦¬μμ€λ₯Ό μ κ±° ν©λλ€.
terraform destroy
```

### *Terraform μ€ν*
> μ¬μ©μ ν°λ―Έλμμ μμ€ μ½λλ₯Ό λ΄λ €λ°μ νμ Terraform applyλ‘ k8s λ¦¬μμ€ νλ‘λΉμ λ
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
### *Terraform μ€ν μμ *
> `IAM User`μ€μ `Access Key Pair`λ₯Ό μμ νλ©΄μ `150μΌ` μ΄νλ‘ κ΅μ²΄νμ§ μμ `IAM User`λ₯Ό μ°Ύμλ΄μ΄ μΆλ ₯ν©λλ€.
1. `terraform.tfvars` νμΌμ μ΄μ΄μ λ³μλ₯Ό μ€μ  ν©λλ€. μ¬κΈ°μμ `accesskey_unused_days`λ³μλ 150μΌ(day)μ λν κ°μ μ§μ ν©λλ€. 
    ```sh
    ////////////////////////
    ///   k8s Variables
    ///////////////////////
    k8s_namespace         = "task-nm" # k8s λ€μμ€νμ΄μ€ μ΄λ¦ λ³μ
    create_k8s_job        = true # k8s job μ€λΈμ νΈ μμ±μ λ¬΄ (true: μμ±, false: λ―Έμμ±)
    create_k8s_cronjob    = true # k8s Cronjob μ€λΈμ νΈ μμ±μ λ¬΄ (true: μμ±, false: λ―Έμμ±)
    accesskey_unreplaced_day = "150" # AccessKey μμ± ν κ΅μ²΄λμ§ μμ μΌ(day)μ λν λ³μ
    ```
2. μμ `terraform.tfvars` νμΌ μμ ν `terraform plan`μΌλ‘ μ€ν κ³νμ νμΈν ν `terraform apply` μΌλ‘ λ¦¬μμ€ νλ‘λΉμ λν©λλ€.
    ```sh
    $ terraform apply

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
      + create
    Terraform will perform the following actions:

      # kubernetes_config_map.task-configmap will be created
      + resource "kubernetes_config_map" "task-configmap" {
          + data = {
              + "AWS_ACCESS_KEY_ID"     = (sensitive)  # λ―Όκ° μ λ³΄μ λν΄ Sensitive νλκ·Έλ₯Ό μ€μ νμ¬ λΈμΆ μν κ°μ
              + "AWS_DEFAULT_REGION"    = "ap-northeast-2"
              + "AWS_SECRET_ACCESS_KEY" = (sensitive) # λ―Όκ° μ λ³΄μ λν΄ Sensitive νλκ·Έλ₯Ό μ€μ νμ¬ λΈμΆ μν κ°μ
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
3. `kubectl`μμ μμ±λ Job μ€λΈμ νΈ μ€νλμ΄ Podκ° μ€νλκ³  μ μμ μΌλ‘ μμμ λ§μΉ νμλ `Completed` μνλ‘ μ’λ£λ©λλ€. Podκ° μ€νλ λ Pullλ‘ λ΄λ €λ°λ μ»¨νμ΄λ Imageμλ `aws_iam_detect.sh` μ€ν¬λ¦½νΈ, Python, awscliλ±μ ν¬ν¨νκ³  μμ΅λλ€.
    * *μ»¨νμ΄λ μ΄λ―Έμ§* : https://hub.docker.com/repository/docker/sepiros62/alpine_awscli/general 
    ```sh
    $ kubectl get job -n task-nm
    NAME       COMPLETIONS   DURATION   AGE
    task-job   1/1           28s        106s

    $ kubectl get pod -n task-nm
    NAME             READY   STATUS      RESTARTS   AGE
    task-job-4mwjl   0/1     Completed   0          112s
    ```

4. `minikube` ν΄λ¬μ€ν° λΈλμμ νΈμ€νΈ κ²½λ‘(HostPath)λ₯Ό λ³Όλ₯¨μΌλ‘ μ¬μ©νμ¬ `/tmp/task-volume/final_list_λ μ§.csv` νμΌλ‘ μ€ν κ²°κ³Όλ₯Ό μ μ₯ν©λλ€. μλ μ€ν κ²°κ³Όλ AccessKeyλ₯Ό μμ±νκ³  `150μΌ` μ΄μ κ΅μ²΄νμ§ μμ `IAM UserName`, `AccessKeyId`, `CreateDate`μ λν λ΄μ©μ ν¬ν¨νλ `IAM USER`λ₯Ό μ μ₯ν©λλ€.
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

## μ€ν κ²°κ³Ό
> Kubernetes IDE ν΄μΈ `Lens`μμμ Job μ€ν κ²°κ³Όμ λν λ‘κ·Έ λ΄μ© νμΈ

![image](https://user-images.githubusercontent.com/31501015/155955369-e27742f0-3d3e-4e31-be18-2f93ce3ab2c5.png)
