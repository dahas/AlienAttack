'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "7d36ec207e3d34d319597225f6711ae4",
"assets/AssetManifest.bin.json": "0eca226b67c33d7f03af6c01a735c382",
"assets/AssetManifest.json": "157df1df76735c6da3862a19a29d35b5",
"assets/assets/audio/background.wav": "8d2d873f4169283fb2fc0f35127ceb92",
"assets/assets/audio/explosionBoss.wav": "cbc0e7aefa9617b2a2832e2bea7c4bc8",
"assets/assets/audio/explosionEnemy.wav": "caa6b8de360e6f15d8b4f98aa75e2156",
"assets/assets/audio/explosionPlayer.wav": "62056583f43374cbac8704fe7e7a3272",
"assets/assets/audio/fireballs.wav": "780d1720845e02a72bfcb6977d71455d",
"assets/assets/audio/powerup1.wav": "7d275490cbbd08f51bacff492497c1e9",
"assets/assets/audio/powerup2.wav": "91021a45b2ee3c6ccc5ae01c6fb92e04",
"assets/assets/audio/powerup3.wav": "4311858b1efcaa210b9a5fee162f63b7",
"assets/assets/audio/sandburst.wav": "51e17c537de750ba5f6bd8f188cd60b2",
"assets/assets/audio/shot.wav": "aafd230f5f351ab0109eaa98ba720a47",
"assets/assets/images/asteroid1.png": "5aaa37567769a2e5e510bbf727c2008c",
"assets/assets/images/asteroid2.png": "80759ea6f1af2e75e1fd394f671020e9",
"assets/assets/images/asteroid3.png": "0952663511ebf3a86917ce2a04169318",
"assets/assets/images/asteroid4.png": "3975a5dd7460ed06ca0d778ad7fff51c",
"assets/assets/images/asteroid5.png": "b5f8d111a38a9004f3482b48250b58cd",
"assets/assets/images/boss.png": "d24579f7a2249fc97efe32c126ab1840",
"assets/assets/images/boss_shadow.png": "41133cabc9875ca9b7576f386a37735e",
"assets/assets/images/bullet.png": "bec499be26502e7f7e0776375c5af6c9",
"assets/assets/images/enemy.png": "76e0423f1f380fa3434821c209ed32eb",
"assets/assets/images/explosion.png": "570f0d798f68df0b41e78dde8c858232",
"assets/assets/images/fireball.png": "8876f66bb6c1a67c7b802c8fca34fb72",
"assets/assets/images/life.png": "81b96e8e46d58f9f1070a2e6e2bf1f98",
"assets/assets/images/life_lost.png": "9ed1388c0fd52a47ccfcb8c76475bcf7",
"assets/assets/images/missile1.png": "89ba6d788f6b9c25a80d1be1daff451b",
"assets/assets/images/player.png": "2d8de2fd3214e276140caa94cdd0af6f",
"assets/assets/images/powerup1.png": "b6dbae5e5dec866b0554cacf425dd009",
"assets/assets/images/powerup2.png": "bf8f3ba711d94f62ad52eedeaefe238e",
"assets/assets/images/powerup3.png": "1df516df32c073c9ee9ffe9fd8f8b561",
"assets/assets/images/sandburst.png": "129d4f3b6887095235051ba6f53e696f",
"assets/assets/images/stars_0.png": "8f00775ec40f4d11965630108cdceea1",
"assets/assets/images/stars_1.png": "43b19253e577e35087924587e1035272",
"assets/assets/images/stars_2.png": "ad471171d9aa41778edd511854a96e81",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/NOTICES": "b03b1ff6ae7cd1ef7a92b24d02c10415",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "552fe4e5bfdbe7bf0dc3f7e57597fdab",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "13ffc6044c27838288b12acf54528f66",
"/": "13ffc6044c27838288b12acf54528f66",
"main.dart.js": "1896e67104aacf017d8ec876de5502e9",
"manifest.json": "4ebfe9754aa7fcae796ae7a785b90c80",
"version.json": "9fc540f32326d5b60d77d0eaf4b6501a"};
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
