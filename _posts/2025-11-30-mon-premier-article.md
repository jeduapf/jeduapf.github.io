---
# Required fields
layout: post
title: Your Blog Post Title Here
date: 2025-11-30 19:00:00+01:00
description: A brief, compelling description of your post (shown in blog listing)
lang: fr  # Use: en, fr, or pt

# Optional: Tags and Categories
tags: tag1 tag2 tag3
categories: category1

# Optional: Comments (requires Disqus configuration)
# comments: true

# Optional: Redirect to external URL or PDF
# redirect: https://example.com/external-post
# redirect: /assets/pdf/my-document.pdf

# Optional: External source attribution  
# external_source: Medium

# Optional: For inline news-style posts (shows content inline in news feed)
# inline: true

# Optional: Authors (mainly for distill layout)
# authors:
#   - name: Your Name
#     url: "https://yourwebsite.com"
#     affiliations:
#       name: Your Institution

# Optional: Bibliography file (for academic posts with citations)
# bibliography: your-references.bib

# Optional: Table of contents (for distill layout)
# toc:
#   - name: Section 1
#   - name: Section 2
#     subsections:
#       - name: Subsection 2.1
#       - name: Subsection 2.2

# Optional: Custom styles (advanced)
# _styles: >
#   .custom-class {
#     color: blue;
#   }
---

## Your Content Starts Here

Write your blog post content using Markdown. You can use:

- **Bold text** with `**text**`
- *Italic text* with `*text*`
- [Links](https://example.com)
- `inline code`
- And much more!

### Code Blocks

```python
def hello_world():
    print("Hello, World!")
```

### Math Equations

Inline math: $$ E = mc^2 $$

Display math:
$$
\sum_{i=1}^{n} x_i = X
$$

### Images

Include images with the figure helper:

{% include figure.html path="assets/img/your-image.jpg" class="img-fluid rounded z-depth-1" %}

---

**Remember**: 
- File must be named: `YYYY-MM-DD-your-post-title.md`
- Place in `_posts/` directory
- The `lang` field determines which language version of the site will show this post
