# Interview Questions and Answers: MLOps, DevOps, and Terraform

## DevOps Interview Questions

### Q1. How do you handle configuration management for a dynamic pool of servers?
* **Answer**: Configuration management for dynamic pools is solved using tools like Ansible, Chef, or Puppet combined with Auto Scaling Groups. Nodes register automatically with the master or run Ansible Pull from a centralized Git repo at startup via user-data.
* **Scenario**: Scaling a web service during peak hours while ensuring new instances receive the latest configuration updates.

### Q2. What is the difference between Continuous Deployment and Continuous Delivery?
* **Answer**: Continuous Delivery ensures code is automatically built, tested, and staged for production, but deployment to prod requires manual approval. Continuous Deployment automates the final step, pushing changes to production without human intervention.
* **Scenario**: A financial application requires QA sign-off (Continuous Delivery), whereas a social media feature flag application deploys directly to prod (Continuous Deployment).

### Q3. Explain the GitOps methodology.
* **Answer**: GitOps uses Git as the single source of truth for declarative infrastructure and applications. Agents (like ArgoCD or Flux) reconcile the active state in the cluster with the repository state.
* **Scenario**: Managing Kubernetes microservices manifests in Git and auto-deploying via ArgoCD.

### Q4. What is a Canary Deployment?
* **Answer**: It rolls out changes to a small subset of users (e.g., 5%) before deploying to the entire user base, minimizing the impact of potential bugs.
* **Scenario**: Updating a payments service and exposing it first to users in a single city.

### Q5. How does a reverse proxy differ from a forward proxy?
* **Answer**: A forward proxy acts on behalf of clients (users) to access external websites. A reverse proxy acts on behalf of backend servers to receive incoming client requests.
* **Scenario**: Using Nginx to load balance incoming client requests across three application containers.

### Q6. What is the purpose of a sidecar container in Kubernetes?
* **Answer**: It runs alongside the primary container to provide helper services like logging, monitoring, or service-mesh proxies.
* **Scenario**: Running a Envoy proxy next to a Spring Boot app for service mesh telemetry.

### Q7. How do you manage secrets securely in a CI/CD pipeline?
* **Answer**: Secrets are stored in secure managers (AWS Secrets Manager, HashiCorp Vault) and referenced dynamically instead of being hardcoded in configuration files.
* **Scenario**: Fetching DB credentials using HashiCorp Vault inside a GitHub Actions workflow.

### Q8. What is the difference between Blue-Green and Rolling updates?
* **Answer**: Blue-Green deploys two identical environments, switching traffic instantly. Rolling updates replace old containers with new ones incrementally.
* **Scenario**: Upgrading a high-traffic e-commerce portal with zero downtime using Blue-Green to allow quick rollback.

### Q9. What is infrastructure drift and how do you monitor it?
* **Answer**: Drift occurs when manual changes are made directly to cloud resources, diverging from the IaC state. It is detected using scheduled execution plans or drift-detection tools.
* **Scenario**: An engineer manually modifies a security group rule, which Terraform identifies and reverts on the next run.

### Q10. How do you implement logging and monitoring for microservices?
* **Answer**: Aggregate logs using an ELK or EFK stack, and collect metrics using Prometheus scraped endpoints visualized via Grafana dashboards.
* **Scenario**: Monitoring response latencies and memory usage of 50 Kubernetes microservices.

### Q11. Explain chaos engineering.
* **Answer**: The practice of intentionally introducing failures into a system to test resilience and recovery procedures.
* **Scenario**: Simulating network latency or terminating random pods in staging to check if the app recovers gracefully.

### Q12. What are the benefits of containerization over virtualization?
* **Answer**: Containers share the host OS kernel, making them lightweight, faster to boot, and highly portable compared to VMs.
* **Scenario**: Deploying 20 containers on a single host instead of spinning up 20 resource-heavy VMs.

### Q13. How do you secure container images in ECR?
* **Answer**: Use Image Scanning (Clair/Amazon Inspector) to find CVEs, enforce IAM policies, and sign images using Docker Content Trust.
* **Scenario**: Preventing container deployment to production if high-severity CVEs are discovered.

### Q14. What is ChatOps?
* **Answer**: Integrating operations tasks with chat applications (like Slack/Teams) using bots to trigger deployments or query system health.
* **Scenario**: Typing `/deploy production service-x` in Slack to initiate a Jenkins job.

### Q15. What are the key metrics in DORA?
* **Answer**: Deployment Frequency, Lead Time for Changes, Mean Time to Recovery (MTTR), and Change Failure Rate.
* **Scenario**: Using JIRA and GitHub telemetry to generate a monthly report on engineering velocity.

### Q16. How does horizontal autoscaling work in Kubernetes?
* **Answer**: HPA scales the number of pod replicas based on CPU, memory, or custom metrics usage.
* **Scenario**: Scaling pods from 2 to 10 during an unexpected traffic spike on an API gateway.

### Q17. Explain the concept of "Shift Left" in DevSecOps.
* **Answer**: Integrating security checks early in the software development lifecycle, such as during code writing and building.
* **Scenario**: Running static application security testing (SAST) on developer local commits.

### Q18. What is a post-mortem, and why is it blameless?
* **Answer**: A review of an incident focusing on system faults rather than human mistakes, aiming to prevent recurrence.
* **Scenario**: Writing a report on why a database connection pool exhausted, and scheduling structural fixes.

### Q19. How do you implement zero-downtime database migrations?
* **Answer**: Perform multi-step migrations: Add column (nullable), update code to write to both old and new columns, migrate old data, update code to read from new column, drop old column.
* **Scenario**: Renaming a database column on an active user registration table without stopping the website.

### Q20. What is immutable infrastructure?
* **Answer**: Rebuilding the entire server image for updates instead of applying configurations on live running servers.
* **Scenario**: Baking a new AMI with Packer and replacing EC2 instances, rather than running SSH Ansible scripts.

---

## Terraform Interview Questions

### Q21. What is the role of the state file in Terraform?
* **Answer**: It stores the mapping between your configuration files and real-world resources, tracking metadata and resource dependencies.
* **Scenario**: Keeping track of EC2 instances and VPC subnets created, avoiding recreating them on every run.

### Q22. How do you handle secrets in Terraform?
* **Answer**: Do not hardcode them. Use environment variables (prefixed with `TF_VAR_`), external secret stores (Vault, AWS Secrets Manager), or mark variables as `sensitive = true`.
* **Scenario**: Dynamically reading RDS credentials from AWS Secrets Manager using a data source.

### Q23. What is state locking, and why is it necessary?
* **Answer**: A mechanism that locks the state file during execution to prevent concurrent runs from overwriting or corrupting state data.
* **Scenario**: Two developers running `terraform apply` simultaneously; DynamoDB locks the state for the first runner.

### Q24. Explain the difference between `count` and `for_each`.
* **Answer**: `count` uses list index-based loops; deleting an item in the middle shifts all subsequent items. `for_each` loops over maps/sets, indexing by keys, which makes item updates independent.
* **Scenario**: Creating multiple subnet ranges across different availability zones using a map of configs.

### Q25. What are local values in Terraform?
* **Answer**: Work like temporary local variables within a module, helping you avoid repeating the same expressions.
* **Scenario**: Creating standard resource naming conventions by concatenating project name and environment.

### Q26. How do you import existing infrastructure into Terraform?
* **Answer**: Write the resource block in code, then run `terraform import <resource_address> <physical_id>` to fetch it into the state.
* **Scenario**: Taking control of an S3 bucket that was manually created via the AWS Console.

### Q27. What is the purpose of `depends_on`?
* **Answer**: Explictly defines execution order when Terraform cannot determine dependencies implicitly from references.
* **Scenario**: Ensuring an IAM Role policy attachment completes before launching an EC2 instance that assumes that role.

### Q28. What are dynamic blocks?
* **Answer**: Allow generating nested configuration blocks dynamically based on a collection (list/map).
* **Scenario**: Creating a dynamic list of ingress rules inside a security group.

### Q29. Explain the difference between Terraform workspaces and environment folders.
* **Answer**: Workspaces use the same code with different state files. Environment folders use separate code/config modules, enabling explicit changes between environments.
* **Scenario**: Staging needs a different architecture than Dev; using separate folders is safer and clearer.

### Q30. How do you resolve a corrupted state file?
* **Answer**: Use `terraform state` subcommands (like `mv`, `rm`, `pull`, `push`) to safely edit the state instead of modifying JSON directly.
* **Scenario**: Removing a resource from state control because it was deleted manually in AWS.

### Q31. What is the difference between `terraform plan` and `terraform apply`?
* **Answer**: `plan` acts as a read-only execution check showing changes. `apply` executes those modifications on the cloud provider.
* **Scenario**: Verifying that no unintended resources are destroyed before committing changes.

### Q32. How do you handle module versioning?
* **Answer**: Store modules in separate Git repos and reference them using git tags in the module source URL.
* **Scenario**: Pinning a database module to version `v2.1.0` to avoid breaking changes from master.

### Q33. What is the `lifecycle` block in Terraform?
* **Answer**: Customizes resource lifecycle behaviors (e.g., `create_before_destroy`, `prevent_destroy`, `ignore_changes`).
* **Scenario**: Preventing accidental deletion of a production database using `prevent_destroy = true`.

### Q34. How does Terraform determine dependency graph?
* **Answer**: It analyzes references between resource parameters (implicit dependencies) and `depends_on` parameters (explicit dependencies) to build a Directed Acyclic Graph (DAG).
* **Scenario**: Terraform creates the VPC before adding subnets because subnets refer to the VPC ID.

### Q35. What is the use of `terraform taint`?
* **Answer**: Marks a resource for destruction and recreation on the next apply run (deprecated in favor of `terraform apply -replace`).
* **Scenario**: Forcing the rebuild of a VM instance that has corrupted software configuration.

### Q36. Explain Sentinel in Terraform.
* **Answer**: A policy-as-code framework used in Terraform Enterprise to enforce compliance and security rules before resource creation.
* **Scenario**: Denying plans that attempt to create EC2 instances without the "CostCenter" tag.

### Q37. What is `terraform output`?
* **Answer**: Exposes resource properties to the terminal or to other Terraform configurations/scripts.
* **Scenario**: Querying the public IP of a newly created load balancer to configure DNS records.

### Q38. How do you dry-run a destroy command?
* **Answer**: Run `terraform plan -destroy` to inspect what resources will be removed.
* **Scenario**: Ensuring you are only removing dev resources before executing a cleanup.

### Q39. What are data sources in Terraform?
* **Answer**: Allow fetching read-only data from external systems or existing cloud resources.
* **Scenario**: Fetching the latest AMI ID for Amazon Linux 2 to use in EC2 deployment.

### Q40. Why does Terraform not automatically destroy resources created by external tools inside VMs?
* **Answer**: Terraform only tracks resources defined in its state. External file updates or configurations are outside its management domain.
* **Scenario**: A script runs on an EC2 instance and creates an S3 bucket; Terraform will not delete that bucket during a destroy.

---

## MLOps Interview Questions

### Q41. What is the primary goal of MLOps?
* **Answer**: To automate and streamline the machine learning lifecycle, bringing model training, testing, deployment, and monitoring into a robust CI/CD workflow.
* **Scenario**: Scaling the release of new model versions from once a quarter to multiple times a day.

### Q42. How does model deployment differ from traditional software deployment?
* **Answer**: Models depend on both code and data. A model can degrade in performance (model drift) over time even if the code remains unchanged.
* **Scenario**: Deploying a recommendation model that degrades because user behavior trends changed.

### Q43. What is Model Drift and how is it detected?
* **Answer**: The decline of a model's predictive power due to changes in input data distribution (concept/data drift). Detected by comparing real-time inference inputs with training datasets.
* **Scenario**: A fraud detection model's accuracy drops because scammers developed new techniques not present in the training data.

### Q44. Explain Feature Stores.
* **Answer**: A centralized repository to store, share, and serve curated machine learning features for training (offline) and low-latency inference (online).
* **Scenario**: Ensuring the offline training script and online payment API use the exact same calculation for "user_last_30_day_spend".

### Q45. What is a SageMaker Domain?
* **Answer**: A managed workspace environment on AWS that provides shared storage, user profiles, and integrations for SageMaker Studio and notebooks.
* **Scenario**: Setting up a collaborative data science workspace with centralized directories and IAM permissions.

### Q46. What is the role of MLflow?
* **Answer**: A tool for tracking experiments (parameters, metrics, code versions), packaging models, and managing registry workflows.
* **Scenario**: Comparing training runs of various deep learning models to select the one with the lowest validation loss.

### Q47. How do you implement automated model retraining?
* **Answer**: Configure pipelines (e.g., using SageMaker Pipelines or Airflow) triggered by drift detection alarms, scheduled timers, or new dataset arrivals on S3.
* **Scenario**: Triggering a retraining job every Sunday using new data gathered during the week.

### Q48. What is the difference between batch inference and real-time inference?
* **Answer**: Batch inference runs on a collection of data offline (high throughput). Real-time inference handles request-response patterns under low latency.
* **Scenario**: Calculating weekly churn risk scores for millions of users (batch) vs. predicting fraud during a transaction checkout (real-time).

### Q49. How do you deploy models using Shadow Deployments?
* **Answer**: Send production traffic to both the active model and the candidate model, but only return the active model's response. The candidate model's predictions are logged for evaluation.
* **Scenario**: Testing a new model's performance on real-world inputs without risking user experience.

### Q50. Explain Model Registry.
* **Answer**: A centralized hub to register, version, track history, and manage production stages (Staging, Production, Archived) of ML models.
* **Scenario**: Promoting a model version from Staging to Production after it passes performance benchmarks.

### Q51. What is containerization's role in MLOps?
* **Answer**: It packages model dependencies, libraries, and runtime environments to prevent dependency conflicts between development and production.
* **Scenario**: Serving a PyTorch model requiring specific CUDA libraries on an AWS EKS cluster.

### Q52. How do you handle versioning for datasets?
* **Answer**: Use tools like DVC (Data Version Control) or S3 Object Versioning to track changes in data files via Git commit hashes.
* **Scenario**: Rolling back to a previous training dataset to reproduce a specific model behavior.

### Q53. What is A/B testing in model deployment?
* **Answer**: Directing a percentage of traffic (e.g., 50%) to Model A and the rest to Model B, then monitoring business metrics to choose the winner.
* **Scenario**: Testing if a new search ranking model increases conversion rate compared to the current model.

### Q54. How do you monitor SageMaker endpoints for drift?
* **Answer**: Enable SageMaker Model Monitor to capture incoming requests and predictions, comparing them against baseline statistics using CloudWatch alerts.
* **Scenario**: Alerting the MLOps team if the average predicted price shifts by more than 15%.

### Q55. What is ONNX?
* **Answer**: Open Neural Network Exchange, an open standard format for representing ML models, enabling portability across different frameworks and runtimes.
* **Scenario**: Training a model in PyTorch and deploying it on a high-performance C++ backend.

### Q56. What is Hyperparameter Tuning?
* **Answer**: The process of optimizing model configurations (e.g., learning rate) by running multiple training jobs (hyperparameter tuning jobs) to find the best model.
* **Scenario**: Running 50 parallel training jobs in SageMaker to find the optimal combination of parameters.

### Q57. How do you optimize inference costs on AWS?
* **Answer**: Use Multi-Model Endpoints (MME), AWS SageMaker Serverless Inference, or host models on AWS Inferentia chips.
* **Scenario**: Hosting 100 rarely-used models on a single SageMaker Serverless endpoint to avoid paying for idle GPU instances.

### Q58. What is a DAG in ML pipelines?
* **Answer**: A Directed Acyclic Graph representing the steps (e.g., preprocessing, training, evaluation) of an ML workflow and their execution order.
* **Scenario**: Structuring a pipeline where model evaluation runs only after both data preprocessing and model training complete.

### Q59. Explain the concept of cold start in serverless inference.
* **Answer**: The latency delay caused when a serverless function or model endpoint initializes a new container to serve its first request.
* **Scenario**: The first user visiting a site experiences a 5-second delay while the container boots up.

### Q60. How do you ensure reproducibility in ML?
* **Answer**: Track code versions (Git), dataset versions (DVC/S3 versioning), environment configurations (Docker), and random seeds.
* **Scenario**: A data scientist reproducing the exact validation accuracy of a model trained six months ago by checking out the tagged code and data.
