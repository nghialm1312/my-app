cat > deploy-frontend.sh << 'EOF'
#!/usr/bin/env bash
set -e
set -x

echo "Writing SSH key..."
echo "$SSH_KEY" > /tmp/deploy_key
chmod 600 /tmp/deploy_key

# Sync Vite build output to Droplet
rsync -az --delete -e "ssh -i /tmp/deploy_key -o StrictHostKeyChecking=no" \
  ./frontend/dist/ \
  "${SSH_USER}@${SSH_HOST}:/var/www/frontend/"

# Reload nginx
ssh -i /tmp/deploy_key -o StrictHostKeyChecking=no "${SSH_USER}@${SSH_HOST}" << 'REMOTE'
sudo systemctl reload nginx || true
REMOTE
EOF
