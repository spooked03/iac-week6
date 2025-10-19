FROM caddy:alpine

# Copy the dist directory contents to Caddy's default serving directory
COPY dist /usr/share/caddy

# Expose port 80
EXPOSE 80

# Caddy will automatically serve files from /usr/share/caddy
# The default Caddyfile serves static files from this directory
