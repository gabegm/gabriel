# Resume Revision Design

## Objective

Strengthen the resume for senior backend, pricing/platform, and applied-AI roles while keeping the generated PDF to one page and avoiding confidential or unsupported claims.

## Positioning

Present Gabriel as a senior software engineer with nine years of experience and a differentiated combination of backend engineering, data science, geospatial modelling, pricing systems, and applied AI.

Add this professional summary:

> Senior software engineer with nine years of experience building cloud-native backend, pricing, geospatial and machine-learning systems. Combines production Java and AWS expertise with a data-science background, taking complex systems from modelling and architecture through delivery and operational ownership.

## Experience

Group the three consecutive SIXT positions beneath one company heading while retaining their distinct titles and dates. Keep the underlying work records flat and adjust only the Hugo presentation logic required to suppress repeated company headings.

Use five concise bullets for the current Senior Software Engineer position:

- Led end-to-end delivery of SIXT Share's dynamic pricing engine across seven cities in two countries, combining H3 geospatial modelling with production demand forecasting.
- Built a walk-forward backtesting framework, selected the strongest demand-forecasting model and productionised it within the dynamic pricing platform.
- Led backend delivery of kilometre-based pricing and quote APIs, expanding customer pricing options through cross-team coordination with mobile engineers.
- Built reusable AI agents for designing and analysing Statsig A/B tests and refining backend tickets, published internally and adopted by engineers across multiple teams.
- Owned pricing and billing reliability, resolving high-impact authorisation, regression and data-integrity incidents and strengthening production safeguards.

Do not mention SIXT Share's profitability. Product-level profitability was not found in public company disclosures, and the available evidence does not establish exclusive causation by dynamic pricing.

Use two bullets for the 2022–2025 Software Engineer position:

- Built and operated Java and Go microservices on AWS supporting SIXT's mobility platform, with responsibility spanning implementation, deployment and production behaviour.
- Led migrations of legacy Java and Go services to Spring Boot and Go Micro, reducing the legacy footprint and improving maintainability and operational consistency.

Keep the older data-science positions to one bullet each to preserve the one-page layout.

## Projects

Prioritise these two projects:

- Shopping Cart: describe its current Java 21, Spring Boot, React, and PostgreSQL stack and highlight its production-oriented security and testing approach.
- Gatekeeping: describe it as an enterprise headcount-planning and approval system migrated from Flask/SQLite to Spring Boot/PostgreSQL.

Retain Job Grader if the generated PDF remains a readable single page; otherwise remove it before reducing type size or spacing. The final render fits on one page, so Job Grader remains included.

## Skills and Metadata

- Change `Spring (Boot)` to `Spring Boot`.
- Change `Postgres` to `PostgreSQL`.
- Remove Git from the skills list.
- Place Gradle with the language/framework toolchain.
- Organise skills as Languages & Frameworks, Cloud & Distributed Systems, Data & Observability, Applied AI & Experimentation, and Languages.
- Remove redundant agent terminology where practical.
- Use `https://gabriel.gaucimaistre.com` for the website.
- Remove empty fields and the empty awards section.
- Preserve British English throughout.

## Template and Verification

- Render the professional summary below the contact header.
- Group consecutive SIXT roles visually under a single company heading.
- Render job titles in bold to make career progression easier to scan.
- Preserve clear role titles and dates for ATS parsing.
- Generate the PDF with `scripts/build-resume-pdf.sh`.
- Verify valid JSON, a successful Hugo build, readable output, and a one-page PDF.
- Do not commit any changes.
