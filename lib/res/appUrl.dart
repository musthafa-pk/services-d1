class AppUrl{

  // static String baseUrl                  = "http://localhost:3003/";

  static String G_MAP_KEY                   = "AIzaSyB--h2bl_kZ_p1FJlRVApPhDziQDkm_gmw" ;

  // static geocodeUrl                      = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${apiKey}";

  // static var baseUrl                     =   'http://13.232.117.141:3003/';
  static const baseUrl                      = 'https://test.apis.dr1.co.in/';


  // <<<<<<<<<<<<<<<<services>>>>>>>>>>>>>>>>>>>>>>>>>

  // bh
  static String hospitalasistenquiry        =   baseUrl+'services/addhospitalassistenquiry';
  static String hospitalasistenquiryData    =   baseUrl+'services/addhospitalassist';
  // ab
  static String addhomeservice              =   baseUrl+'services/addhomeservice';
  static String addhomeServiceenquiry       =   baseUrl+'services/addhomeServiceenquiry';

  static String physiotherapyenquiry        =   baseUrl+'services/physiotherapyenquiry';
  static String addphysiotherapy            =   baseUrl+'services/addphysiotherapy';
  static String gethospitals                =   baseUrl+'hospital/list';
  static String getserviceenquiries         =   baseUrl+'services/myorders';


  // <<<<<<<<<<<<<<<<services>>>>>>>>>>>>>>>>>>>>>>>>>


  // <<<<<<<<<<<<<<<<<<<<<<<<<<<doctor one urls>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  static String getProfile          = baseUrl+'user/getprofile';

  static String edituser            = baseUrl+'user/edituser';

  static String userLogin           = baseUrl+'user/userlogin';

  static String addusers            = baseUrl+'user/addusers';

  static String getCart             = baseUrl+'pharmacy/getCart';

  static String addToCart           = baseUrl+'pharmacy/addToCart';

  static String removeFromCart      = baseUrl+'pharmacy/removeFromCart';

  static String getproducts         = baseUrl+'pharmacy/getproducts';

  static String products            = baseUrl+'product/products';

  static String myorders            = baseUrl+'pharmacy/myorders';

  static String singleProduct       = baseUrl+'pharmacy/getproductdetail';

  static String allProduct          = baseUrl+'product/products';
  static String allProduct_LoggedIn = baseUrl+'product/productsApp';

  static String productCategory     = baseUrl+'product/getcategory';

  static String salesOrder          = baseUrl+'pharmacy/salesorder';


  // <<<<<<<<<<<<<<<<<<<<<<<<<<<doctor one urls>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
}

