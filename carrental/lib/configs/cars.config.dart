class Car {
  final String title;
  final String image;
  Car({required this.title, required this.image});
}

List<Car> cars = [
  Car(image: "land-crusier.png", title: "Land Crusier"),
  Car(image: "baleno.png", title: "Baleno"),
  Car(image: "scorpio.png", title: "Scorpio"),
  Car(image: "hiace.png", title: "Hiace"),
  Car(image: "alto.png", title: "Alto"),
];

Car getCar(String title) {
  Car carTemp = cars.first;
  for (Car car in cars) {
    if (car.title == title) {
      carTemp = car;
    }
  }
  return carTemp;
}
