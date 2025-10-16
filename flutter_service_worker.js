'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "7bbc62408007ce3f47d1f906aa987a80",
"icons/Icon-maskable-512.png": "0fa379e282b82eae1de061fcbf4b0144",
"icons/Icon-192.png": "8d8492091f5ddd9bcea2693fce1b2170",
"icons/Icon-maskable-192.png": "9ad6079fd25b99d8f79729049cad429b",
"manifest.json": "fb7d9a2af8fc06938dfcfcfdf7d1fb27",
"index.html": "b93d7332437a9dbecd6c73143cfc7a52",
"/": "b93d7332437a9dbecd6c73143cfc7a52",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "d2dfb49713902d98917f6b3eecc697dd",
"assets/assets/images/sandburst.png": "129d4f3b6887095235051ba6f53e696f",
"assets/assets/images/asteroid1_fragment4.png": "b76f566e5d4402fad44ce56e888156d4",
"assets/assets/images/asteroid2_fragment4.png": "5935216572f349ed4a618dc530a8da99",
"assets/assets/images/boss.png": "a700ad3ddef985f9237d14c06a05f93c",
"assets/assets/images/asteroid1_fragment5.png": "9cd1d5ccb4cfd5094c13409a7ad3617f",
"assets/assets/images/asteroid1_fragment1.png": "a5db750d2ed8a57ef440dd34b9641ae6",
"assets/assets/images/asteroid2_fragment3.png": "5f75a34636c5dc933777b47440cbe391",
"assets/assets/images/life.png": "81b96e8e46d58f9f1070a2e6e2bf1f98",
"assets/assets/images/powerup3.png": "1df516df32c073c9ee9ffe9fd8f8b561",
"assets/assets/images/boss_fragment5.png": "960653bf3b79a971500e51f2dee590a6",
"assets/assets/images/player.png": "2d8de2fd3214e276140caa94cdd0af6f",
"assets/assets/images/asteroid1_fragment3.png": "e7da7423020144ab15b234e2b0534bc0",
"assets/assets/images/asteroid5_fragment5.png": "3b573f0fdfdbb8d92ce812a1732f69f9",
"assets/assets/images/asteroid4.png": "62caf481f216cc2fe082c8bee510b189",
"assets/assets/images/boss_fragment4.png": "0b1566eee5e3c8f66ebc624de32eb50f",
"assets/assets/images/fireball.png": "dec8218d34c8ca5d91ca7cf749cb8b72",
"assets/assets/images/stars_1.png": "43b19253e577e35087924587e1035272",
"assets/assets/images/asteroid4_fragment5.png": "3789dac164749fc653f5cb286d01fd7a",
"assets/assets/images/asteroid2_fragment2.png": "8a358fa4a1b56937dbb37084fee8650c",
"assets/assets/images/enemy.png": "b0d46b76a65a124b3f029440aeaa1028",
"assets/assets/images/boss_fragment2.png": "47bf52a4fc485c734758544431c705ee",
"assets/assets/images/boss_fragment3.png": "dba881cdc07c6b7e06fba615a1d3581f",
"assets/assets/images/asteroid5_fragment3.png": "427139cbf6f225a73d2fb1800710e0c1",
"assets/assets/images/explosion.png": "acfc6541f7a28b4d86edd0ee4b849f1e",
"assets/assets/images/asteroid4_fragment1.png": "92fa0f6b458b9c4e7f24e82a8a30204e",
"assets/assets/images/asteroid3_fragment4.png": "7c569e30e39a599e44e6fda8bb184c36",
"assets/assets/images/stars_2.png": "ad471171d9aa41778edd511854a96e81",
"assets/assets/images/asteroid3.png": "e315aa3819a11938aad0bfd3272eefea",
"assets/assets/images/asteroid5_fragment2.png": "2ccd7df5a5edbece85a4f955b8e6c6f0",
"assets/assets/images/bullet.png": "bec499be26502e7f7e0776375c5af6c9",
"assets/assets/images/powerup2.png": "bf8f3ba711d94f62ad52eedeaefe238e",
"assets/assets/images/boss_fragment1.png": "22a58ed128d0d6219ccbed279aa885e4",
"assets/assets/images/asteroid5_fragment1.png": "8af9ffb9909ad46e4fb6a7a14c97004f",
"assets/assets/images/asteroid2_fragment1.png": "9b4e6229d5cdbf9a63bca4061ff6945a",
"assets/assets/images/asteroid3_fragment5.png": "d136858863a390739c2ed41f0a44c12b",
"assets/assets/images/boss_shadow.png": "12a58a8e3f5c94c52ea92c9f8758d2d7",
"assets/assets/images/missile1.png": "4f4a74143eda61c76347add97e4d0227",
"assets/assets/images/life_lost.png": "9ed1388c0fd52a47ccfcb8c76475bcf7",
"assets/assets/images/asteroid2_fragment5.png": "d87ec0bf702d31c3a756ef1b7820996e",
"assets/assets/images/asteroid1.png": "176fdd4bb0a605ee95f3da64c116782a",
"assets/assets/images/asteroid3_fragment3.png": "ce9ff703d21a39c39b9eb7aeeaf3ec3f",
"assets/assets/images/asteroid4_fragment4.png": "1386c25393264552f427921609bd4e0a",
"assets/assets/images/stars_0.png": "8f00775ec40f4d11965630108cdceea1",
"assets/assets/images/asteroid1_fragment2.png": "d14455dc0d35b622d74cd2b2d2f00b1a",
"assets/assets/images/asteroid3_fragment2.png": "a8fd907caff1d12d9173c8be73e8e7e0",
"assets/assets/images/asteroid5.png": "9134a0a39378b9a188a16457f642ec44",
"assets/assets/images/explosion_boss.png": "570f0d798f68df0b41e78dde8c858232",
"assets/assets/images/asteroid4_fragment3.png": "4ba5339a14a6d0ef995688a79bd1d0e3",
"assets/assets/images/asteroid3_fragment1.png": "a0cf0c9cf72f34429fe83732c6e92306",
"assets/assets/images/asteroid5_fragment4.png": "9599b258759b791254299b28b89b6540",
"assets/assets/images/asteroid2.png": "b24eb81bff813702ef06723f427b579c",
"assets/assets/images/powerup1.png": "b6dbae5e5dec866b0554cacf425dd009",
"assets/assets/images/boss_fragment7.png": "40bb531f6dbf083f31117ad78a194ca8",
"assets/assets/images/boss_fragment6.png": "bacfad188b179ad8a55c1474a1fec531",
"assets/assets/images/asteroid4_fragment2.png": "24df880105e6002c28286c3ad27e2b03",
"assets/assets/audio/powerup1.wav": "7d275490cbbd08f51bacff492497c1e9",
"assets/assets/audio/explosionEnemy.wav": "caa6b8de360e6f15d8b4f98aa75e2156",
"assets/assets/audio/explosionBoss.wav": "cbc0e7aefa9617b2a2832e2bea7c4bc8",
"assets/assets/audio/background.wav": "8d2d873f4169283fb2fc0f35127ceb92",
"assets/assets/audio/burst.wav": "9a2e990ab425134e6a5497879e5b4f71",
"assets/assets/audio/shot.wav": "aafd230f5f351ab0109eaa98ba720a47",
"assets/assets/audio/sandburst.wav": "51e17c537de750ba5f6bd8f188cd60b2",
"assets/assets/audio/powerup3.wav": "4311858b1efcaa210b9a5fee162f63b7",
"assets/assets/audio/explosionPlayer.wav": "62056583f43374cbac8704fe7e7a3272",
"assets/assets/audio/powerup2.wav": "91021a45b2ee3c6ccc5ae01c6fb92e04",
"assets/assets/audio/fireballs.wav": "780d1720845e02a72bfcb6977d71455d",
"assets/assets/loader_icon.png": "7bbc62408007ce3f47d1f906aa987a80",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/NOTICES": "02804e71b646f0804679b4a5721eed1e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "f12194b0620b9c6bde797c8ab10dc1fa",
"assets/AssetManifest.json": "1e8c7ad6d3d64778498d14a4a7e77aef",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"favicon.png": "5e494aaa075ed781fbc93b164c6cd864",
"flutter_bootstrap.js": "1ffe9d3b1d539fa6eb300682b6aeede1",
"version.json": "59eaac8ac31c53bce44ebc95718a0c18",
"main.dart.js": "49bd8eca22bdf5f01c92e71dd6237dbd"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
