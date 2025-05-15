enum ESubject{
    note("Notas", "NOTE"),
    interval("Intervalos", "INTERVAL"),
    scale("Escalas", "SCALE"),
    chord("Acordes", "CHORD");

    const ESubject(this.description, this.backendDescription);

    final String description;
    final String backendDescription;
}