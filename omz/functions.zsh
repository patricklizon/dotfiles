killport() {
    lsof -ti :$1 | xargs kill -9;
}
