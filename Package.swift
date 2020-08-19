// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "gRPC",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9)
    ],

  products: [
    .library(
      name: "gRPC-Core",
      targets: [
        "gRPC-Core",
      ]
    ),
    .library(
      name: "gRPC-cpp",
      targets: [
        "gRPC-cpp",
      ]
    )
  ],

  dependencies: [
    .package(
      name: "abseil",
      url: "https://github.com/firebase/abseil-cpp.git",
      .revision("d30bd7751ce343a05fca6413de0dec062163e5e9")
    ),
    .package(name: "BoringSSL-GRPC",
      url: "https://github.com/firebase/boringssl.git",
      .branch("897ffb6fbb5a5ea149216d664ce8b04d77e3df22")
    ),
  ],

  targets: [
    .target(
      name: "gRPC-Core",
      dependencies: [
        .product(name:"abseil", package: "abseil"),
        .product(name:"openssl_grpc", package: "BoringSSL-GRPC"),
      ],
      path: ".",
      exclude: [
        "src/core/ext/filters/load_reporting/",
        "src/core/ext/filters/client_channel/lb_policy/grpclb/grpclb_channel.cc",
        "src/core/ext/filters/client_channel/xds/xds_channel.cc",
        "src/core/ext/transport/cronet",
        "src/core/lib/surface/init_unsecure.cc",
        "src/core/plugin_registry/grpc_unsecure_plugin_registry.cc",
        "third_party/upb/upb/bindings/",
      ],
      sources: [
        "src/core/ext/filters/",
        "src/core/ext/transport/",
        "src/core/ext/upb-generated/",
        "src/core/lib/",
        "src/core/plugin_registry/grpc_plugin_registry.cc",
        "src/core/tsi/",
        "third_party/upb/upb/",
      ],
      publicHeadersPath: "spm-core-include",
      cSettings: [
        .headerSearchPath("./"),
        .headerSearchPath("include/"),
        .headerSearchPath("third_party/upb/"),
        .headerSearchPath("src/core/ext/upb-generated"),
        .define("GRPC_ARES", to: "0"),
        .unsafeFlags(["-Wno-module-import-in-extern-c"]),
      ]
    ),
    .target(
      name: "gRPC-cpp",
      dependencies: [
        .product(name:"abseil", package: "abseil"),
        "gRPC-Core",
      ],
      path: ".",
      exclude: [
        "src/cpp/client/cronet_credentials.cc",
        "src/cpp/common/insecure_create_auth_context.cc",
        "src/cpp/ext/",
        "src/cpp/server/channelz/",
        "src/cpp/server/load_reporter/",
        "src/cpp/util/core_stats.cc",
        "src/cpp/util/core_stats.h",
        "src/cpp/util/error_details.cc",
      ],
      sources: [
        "src/cpp/",
      ],
      publicHeadersPath: "spm-cpp-include",
      cSettings: [
        .headerSearchPath("./"),
        .headerSearchPath("include/"),
        .headerSearchPath("third_party/upb/"),
        .headerSearchPath("src/core/ext/upb-generated"),
        .unsafeFlags(["-Wno-module-import-in-extern-c"]),
      ]
    ),
  ],
  cLanguageStandard: .gnu11,
  cxxLanguageStandard: .cxx11
)
