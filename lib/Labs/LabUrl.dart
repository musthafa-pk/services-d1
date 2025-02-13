class LabUrl{
  // static const port = '3004';
  static const port = '3003';

  // static const hostedip = '52.66.145.37';

  static const hostedip = 'test.apis.dr1.co.in';

  // static const localip = '192.168.1.10';
  // static const hostedip = '13.232.117.141';


  // static var baseUrl = 'http://${hostedip}:${port}';
  // static var baseUrl = 'https://${hostedip}/medone';
  static var baseUrl = 'https://${hostedip}/labtest';
  // static var baseUrl = 'http://${hostedip}:${port}/timekeeping';

  static var getallPackages = '$baseUrl/getallpackages';

  static var getCartcountandGetCart = '$baseUrl/gettestCart';

  static var addToCart = '$baseUrl/testToCart';

  static var removeFromCart = '$baseUrl/removeTestFromCart';

  static var getallTests = '$baseUrl/getalltests';

  static var getnearestLabs = '$baseUrl/getnearestlabs';

  static var packageDetail = '$baseUrl/packagedetail';

  static var get_workList = '$baseUrl/get_worklist';

  static var Labcheckout = '$baseUrl/checkout';

  static var testDetail = '$baseUrl/testdetail';

  static var myOrders = '$baseUrl/myorders';

  static var prescriptionUpload = '$baseUrl/prescriptionupload';

  static var GetorderDetails = '$baseUrl/getorderdetails';








}