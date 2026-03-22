function unproxy --description 'Disable HTTP/SOCKS proxy'
    set -e https_proxy
    set -e http_proxy
    set -e all_proxy
    echo "Proxy disabled"
end
