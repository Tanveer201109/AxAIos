FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ```

### ২. GitHub Actions Workflow (.github/workflows/deploy.yml)
```yaml
name: Build & Deploy CTx Docker

on:
  push:
    branches: jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Login to GitHub Container Registry
      uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Build Docker image
      run: |
        docker build -t ghcr.io/${{ github.repository }}:latest .

    - name: Push Docker image
      run: docker push ghcr.io/${{ github.repository }}:latest

    - name: Deploy to GitHub Pages (optional, static HTML)
      if: always()
      uses: peaceiris/actions-gh-pages@v4
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: .
