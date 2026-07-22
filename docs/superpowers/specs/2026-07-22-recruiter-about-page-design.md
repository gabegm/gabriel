# Recruiter-Focused About Page Design

## Objective

Replace the outdated long-form biography with a concise professional introduction for recruiters and engineering peers. The page should complement the resume by explaining Gabriel's professional identity, career trajectory, and interests without duplicating every resume bullet.

## Audience and Tone

- Prioritise recruiters, hiring managers, and engineering peers.
- Use direct, specific language and British English.
- Retain enough personal context to sound human, but avoid a long autobiography.
- Target approximately 400–600 words.

## Content Structure

### Professional introduction

Open with two short paragraphs covering:

- Nine years across data analysis, data science, and backend engineering.
- Current senior software engineering focus.
- Experience with pricing, geospatial systems, demand forecasting, distributed services, and production ownership.
- The value of combining data-science reasoning with backend engineering delivery.

### Areas of expertise

Use three compact sections:

1. Backend and distributed systems: Java, Spring Boot, Go, AWS, Kafka, gRPC, PostgreSQL, operational ownership, and service modernisation.
2. Data-informed product engineering: forecasting, H3 geospatial modelling, experimentation, optimisation, and commercial product decisions.
3. Applied AI and experimentation: practical AI agents for A/B-testing and engineering workflows, without broad or inflated AI claims.

### Selected projects

Feature the current public repositories:

- Gatekeeping: `https://github.com/gabegm/gatekeeping`
- Shopping Cart: `https://github.com/gabegm/shopping-cart`
- Job Grader: `https://github.com/gabegm/job-grader`

Remove outdated repository names and omit the algorithmic-trading thesis from the primary project list.

### Personal context

Condense the programming origin story into one paragraph: discovering Lua through game modifications, becoming interested in open-source software, and following a non-linear path from data work into backend engineering.

### Contact

Provide explicit links for:

- Email
- LinkedIn
- GitHub
- Resume page

Move the statement that opinions are personal and do not represent current or former employers to unobtrusive text at the bottom.

## Page Behaviour and Metadata

- Update the social/search summary to reflect the current senior backend and data-science positioning.
- Mark the page as `unlisted` so it remains in navigation but does not appear as an old homepage article.
- Suppress the visible publication date on the About page through a narrowly scoped front-matter option and template condition.
- Preserve the existing site typography and theme.

## Verification

- Build the Hugo site successfully.
- Confirm About remains in the main menu.
- Confirm About is absent from the homepage article feed.
- Confirm the publication date is not rendered on About but remains on ordinary posts.
- Check all project, contact, and resume links.
- Review at mobile and desktop widths for readable paragraph length and hierarchy.
