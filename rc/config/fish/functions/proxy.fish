function proxy --description 'Enable HTTP/SOCKS proxy'
    set -gx https_proxy http://127.0.0.1:7890
    set -gx http_proxy http://127.0.0.1:7890
    set -gx all_proxy socks5://127.0.0.1:7890
    echo "Proxy enabled (127.0.0.1:7890)"
end
