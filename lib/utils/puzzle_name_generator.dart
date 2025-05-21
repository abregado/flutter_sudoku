import 'dart:math';

class PuzzleNameGenerator {
  static final List<String> _adjectives = [
    // Positive traits
    'Fröhlich', 'Lustig', 'Glücklich', 'Freundlich', 'Liebenswert', 'Sanft', 'Zärtlich',
    'Mutig', 'Tapfer', 'Stark', 'Kühn', 'Entschlossen', 'Beharrlich', 'Ausdauernd',
    'Klug', 'Weise', 'Intelligent', 'Geschickt', 'Gewandt', 'Gewitzt',
    'Kreativ', 'Phantasievoll', 'Einfallsreich', 'Erfinderisch', 'Innovativ',
    'Fleißig', 'Emsig', 'Tüchtig', 'Arbeitsam', 'Strebsam',
    'Geduldig', 'Ausdauernd', 'Beharrlich', 'Hartnäckig', 'Zäh',
    'Höflich', 'Rücksichtsvoll', 'Respektvoll', 'Achtsam', 'Aufmerksam',
    'Zuverlässig', 'Verlässlich', 'Vertrauenswürdig', 'Treu', 'Loyal',
    'Hilfsbereit', 'Großzügig', 'Freigiebig', 'Mildtätig', 'Wohltätig',
    'Bescheiden', 'Demütig', 'Zurückhaltend', 'Unprätentiös', 'Schlicht',
    'Neugierig', 'Wissbegierig', 'Lernbegierig', 'Forschend', 'Erkundend',
    'Optimistisch', 'Hoffnungsvoll', 'Zuversichtlich', 'Positiv', 'Aufgeschlossen',
    'Energisch', 'Dynamisch', 'Vital', 'Lebhaft', 'Tatkräftig',
    'Ordnungsliebend', 'Sorgfältig', 'Gewissenhaft', 'Präzise', 'Akribisch',
    'Anpassungsfähig', 'Flexibel', 'Wendig', 'Geschmeidig', 'Elastisch',
    'Verantwortungsbewusst', 'Pflichtbewusst', 'Gewissenhaft', 'Sorgsam', 'Achtsam',
    'Ehrlich', 'Aufrichtig', 'Redlich', 'Wahrhaftig', 'Glaubwürdig',
    'Selbstbewusst', 'Souverän', 'Gelassen', 'Ruhig', 'Ausgeglichen',
    'Künstlerisch', 'Musikalisch', 'Kreativ', 'Gestalterisch', 'Schöpferisch',
    'Sportlich', 'Athletisch', 'Kraftvoll', 'Beweglich', 'Geschickt'
  ];

  static final List<String> _animals = [
    // Domestic animals
    'Hund', 'Katze', 'Maus', 'Hase', 'Kaninchen', 'Hamster', 'Meerschweinchen',
    'Pferd', 'Esel', 'Ziege', 'Schaf', 'Kuh', 'Schwein', 'Huhn', 'Ente',
    // Wild animals
    'Wolf', 'Fuchs', 'Bär', 'Löwe', 'Tiger', 'Leopard', 'Gepard', 'Jaguar',
    'Elefant', 'Giraffe', 'Zebra', 'Antilope', 'Gazelle', 'Hirsch', 'Reh',
    'Affe', 'Gorilla', 'Schimpanse', 'Orang-Utan', 'Lemur',
    'Panda', 'Koala', 'Känguru', 'Wombat', 'Echidna',
    'Delfin', 'Wal', 'Robbe', 'Seehund', 'Otter',
    'Adler', 'Falke', 'Bussard', 'Eule', 'Uhu',
    'Pinguin', 'Papagei', 'Kakadu', 'Wellensittich', 'Kanarienvogel',
    'Schlange', 'Eidechse', 'Gecko', 'Chamäleon', 'Leguan',
    'Frosch', 'Kröte', 'Salamander', 'Molch', 'Axolotl',
    'Schmetterling', 'Biene', 'Hummel', 'Libelle', 'Grille',
    'Ameise', 'Spinne', 'Tausendfüßler', 'Skorpion', 'Marienkäfer',
    'Fisch', 'Krabbe', 'Garnelle', 'Muschel', 'Seestern',
    'Schnecke', 'Regenwurm', 'Tausendfüßler', 'Assel', 'Mücke',
    'Fledermaus', 'Igel', 'Maulwurf', 'Feldmaus', 'Ratte',
    'Eichhörnchen', 'Dachs', 'Marder', 'Wiesel', 'Hermelin',
    'Luchs', 'Wildkatze', 'Serval', 'Ozelot', 'Puma',
    'Nashorn', 'Nilpferd', 'Tapir', 'Okapi', 'Gnu',
    'Kamel', 'Lama', 'Alpaka', 'Yak', 'Büffel',
    'Gorilla', 'Orang-Utan', 'Schimpanse', 'Bonobo', 'Gibbon',
    'Panda', 'Koala', 'Wombat', 'Känguru', 'Echidna'
  ];

  static String _conjugateAdjective(String adjective, String animal) {
    // Basic German adjective conjugation rules
    if (animal.startsWith(RegExp(r'[aeiouäöü]'))) {
      // If animal starts with a vowel, add 'r' to the adjective
      return '${adjective}r';
    } else {
      // Otherwise, add 'er' to the adjective
      return '${adjective}er';
    }
  }

  static String generateName(String id) {
    // Use the first 4 characters of the ID to generate a deterministic name
    final seed = int.parse(id.substring(0, 4), radix: 16);
    final random = Random(seed);
    
    final adjective = _adjectives[random.nextInt(_adjectives.length)];
    final animal = _animals[random.nextInt(_animals.length)];
    
    // Conjugate the adjective based on the animal
    final conjugatedAdjective = _conjugateAdjective(adjective, animal);
    
    return '$conjugatedAdjective $animal';
  }
} 