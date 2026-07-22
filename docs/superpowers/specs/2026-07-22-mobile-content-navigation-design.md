# Mobile Content Navigation Design

## Objective

Remove the false impression that an internal navigation link did nothing on mobile, while preserving the site's existing Hyde sidebar design and desktop behaviour.

## Navigation Behaviour

- Give the primary content landmark the stable fragment identifier `main`.
- Append `#main` to internal navigation destinations, including Home and Resume.
- Leave external destinations such as GitHub, Bluesky, LinkedIn, and RSS unchanged.
- Keep the navigation label `Resume`; do not change it to `Résumé`.

When a visitor selects an internal page from the mobile sidebar, the destination page should load with its primary content visible rather than leaving the visitor at the top of the sidebar.

## Implementation Boundaries

- Update the base layout to identify the main content landmark.
- Update the sidebar partial to distinguish internal and external destinations.
- Add narrowly scoped responsive styles to the existing Hyde stylesheet.
- Do not introduce a hamburger menu, JavaScript, animation framework, or broader theme redesign.

## Verification

- Build the Hugo site successfully.
- Confirm Home and Resume links include `#main`.
- Confirm external URLs are unchanged.
- Test direct page loads and navigation at 320px, 375px, 768px, and desktop width.
- Confirm semantic landmark behaviour.
