enum ESubject{
    note("Notas"),
    interval("Intervalos"),
    scale("Escalas"),
    chord("Acordes");

    const ESubject(this.description);

    final String description;
}