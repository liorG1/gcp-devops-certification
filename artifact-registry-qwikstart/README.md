# Artifact Registry Qwik Start Lab
Completed artifact registry lab using private project terraform-learning-503012 in us-west4.
מעבדה זו בוצעה ישירות מסביבת הפיתוח המקומית (WSL + VS Code) מול חשבון ה-GCP האישי, כחלק מההכנה להסמכת GCP DevOps Engineer.

## פרטי הסביבה
* **Project ID:** `terraform-learning-503012`
* **Region:** `us-west4`
* **Zone:** `us-west4-a` / `us-west4-b` / `us-west4-c`
* **GitHub Repository:** `git@github.com:liorG1/gcp-devops-certification.git`

---

## פקודות המעבדה לביצוע (שלב אחר שלב)

### שלב 1: הגדרת משתני סביבה בטרמינל
נשמור את מזהה הפרויקט והאזור כמשתנים כדי להקל על הרצת הפקודות הבאות:
```bash
export PROJECT_ID=terraform-learning-503012
export REGION=us-west4

gcloud artifacts repositories create example-docker-repo \
    --repository-format=docker \
    --location=$REGION \
    --description="Docker repository" \
    --project=$PROJECT_ID

gcloud artifacts repositories list --project=$PROJECT_ID
gcloud auth configure-docker us-west4-docker.pkg.dev
# 1. משיכת האימג' הציבורי לתוך ה-WSL
docker pull us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0

# 2. תיוג האימג' מחדש עבור המאגר שלך
docker tag us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0 \
us-west4-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

# 3. דחיפת האימג' ל-Artifact Registry של GCP
docker push us-west4-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1
# מחיקת העותק המקומי ב-WSL
docker rmi us-west4-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1

# משיכה מחדש ישירות מהענן שלך
docker pull us-west4-docker.pkg.dev/$PROJECT_ID/example-docker-repo/sample-image:tag1
