// Server URL - automatically detected based on device type
// For physical devices, set manualPhysicalDeviceIP in server_config.dart
// For emulators, uses 10.0.2.2 automatically
String SERVER_URL = 'http://10.0.2.2:5000'; // Default, will be updated on app init
const ONESIGNAL_APP_ID = 'YOUR_ONE_SIGNAL_APP_ID';
const CURRENCY_SYMBOL = "৳";

// preference keys, no need to change
const FAVORITE_PRODUCT_BOX = 'FAVORITE_PRODUCT_BOX';
const USER_INFO_BOX = 'USER_INFO_BOX';
const PHONE_KEY = 'PHONE_KEY';
const STREET_KEY = 'STREET_KEY';
const CITY_KEY = 'CITY_KEY';
const STATE_KEY = 'STATE_KEY';
const POSTAL_CODE_KEY = 'POSTAL_CODE_KEY';
const COUNTRY_KEY = 'COUNTRY_KEY';

// sorting options
const SORT_PRICE_LOW_TO_HIGH = 'Low To High';
const SORT_PRICE_HIGH_TO_LOW = 'High To Low';
const CATEGORY_ALL = 'All';

// do not change, if you must then edit from server-side too
const PAYMENT_METHOD_COD = 'COD';
const PAYMENT_METHOD_PREPAID = 'Prepaid';

// do not change
const ORDER_STATUS_ALL = 'All orders';
const ORDER_STATUS_PENDING = 'Pending';
const ORDER_STATUS_PROCESSING = 'Processing';
const ORDER_STATUS_SHIPPED = 'Shipped';
const ORDER_STATUS_DELIVERED = 'Delivered';
const ORDER_STATUS_CANCELLED = 'Cancelled';
