if ! id helloapp &>/dev/null; then
    useradd helloapp -s /sbin/nologin -M
fi
