cat > deploy-backend.sh << 'EOF'
#!/usr/bin/env bash
set -e
set -x

echo "Writing SSH key..."
echo "$SSH_KEY" > /tmp/deploy_key
chmod 600 /tmp/deploy_key

# Sync backend code to Droplet
rsync -az --delete -e "ssh -i /tmp/deploy_key -o StrictHostKeyChecking=no" \
  ./backend/ \
  "${SSH_USER}@${SSH_HOST}:/var/www/backend/"

# Install deps + restart backend with PM2
ssh -i /tmp/deploy_key -o StrictHostKeyChecking=no "${SSH_USER}@${SSH_HOST}" << 'REMOTE'
cd /var/www/backend
npm ci --omit=dev

pm2 describe backend >/dev/null 2>&1
if [ $? -eq 0 ]; then
  pm2 restart backend
else
  pm2 start index.js --name backend
fi

pm2 save
REMOTE
EOF
