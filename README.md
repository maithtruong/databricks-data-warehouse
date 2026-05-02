# 🏗️ Databricks SQL Data Warehouse

Hi, I’m Mai — welcome to this project!

In this project, I build a modern **SQL Data Warehouse** in **Databricks** using the **Medallion Architecture** (**Bronze → Silver → Gold**) to create scalable, traceable, and analytics-ready data pipelines.

The project also integrates **dbt** for automated testing and data quality validation, helping detect issues early and maintain reliable transformations.

Each stage of the workflow is documented with explanations, diagrams, implementation details, and architectural decisions.

---

## 🚀 Project Overview

This project demonstrates:

- Building a layered warehouse architecture in Databricks
- Implementing Bronze, Silver, and Gold data layers
- Data transformation workflows using SQL
- Automated testing and validation with dbt
- Modular and maintainable analytics engineering practices
- Documentation-first workflow with diagrams and explanations

---

## 🛠️ Tech Stack

<p align="left">

<img src="https://img.shields.io/badge/Databricks-EF3E42?style=for-the-badge&logo=databricks&logoColor=white" />

<img src="https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white" />

<img src="https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white" />

<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" />

<img src="https://img.shields.io/badge/Delta_Lake-0A84FF?style=for-the-badge&logo=databricks&logoColor=white" />

<img src="https://img.shields.io/badge/Data_Warehouse-1E293B?style=for-the-badge" />

<img src="https://img.shields.io/badge/Medallion_Architecture-F59E0B?style=for-the-badge" />

</p>

---

## 📚 Documentation

Full project documentation, architecture diagrams, implementation details, and workflow explanations are available here:

👉 **Notion Docs:**  
https://the-data-mage.notion.site/SQL-Databricks-Data-Warehouse-354c5cf0b6be80db98d8f92e90937ab7?source=copy_link

---

## 🧱 Architecture

The warehouse follows the **Medallion Architecture**:

- **Bronze Layer** → Raw ingested data
- **Silver Layer** → Cleaned and transformed data
- **Gold Layer** → Business-ready analytical models

This structure improves:
- Data quality
- Traceability
- Scalability
- Maintainability

---

## ✅ Data Quality

Data quality checks are implemented with **dbt tests** to ensure:

- Schema consistency
- Null validation
- Uniqueness constraints
- Referential integrity
- Reliable downstream analytics

---

## 📌 Notes

This project inherits many concepts from the course by **Data with Baraa**.

Additional modifications were made to align the implementation with more modern analytics engineering and data workflow practices.

---

## 🔗 Related Resources

- Documentation:  
  https://the-data-mage.notion.site/SQL-Databricks-Data-Warehouse-354c5cf0b6be80db98d8f92e90937ab7?source=copy_link

- Data with Baraa:  
  https://www.youtube.com/@DataWithBaraa

---
