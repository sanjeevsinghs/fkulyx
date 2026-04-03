// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

TrendingProductsDataModel trendingProductsDataModelFromJson(String str) =>
    TrendingProductsDataModel.fromJson(json.decode(str));

String trendingProductsDataModelToJson(TrendingProductsDataModel data) =>
    json.encode(data.toJson());

class TrendingProductsDataModel {
  bool? success;
  Data? data;
  String? message;
  int? statusCode;

  TrendingProductsDataModel({
    this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory TrendingProductsDataModel.fromJson(Map<String, dynamic> json) =>
      TrendingProductsDataModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
    "statusCode": statusCode,
  };
}

class Data {
  List<Product>? products;
  Pagination? pagination;

  Data({this.products, this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    products: json["products"] == null
        ? []
        : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  bool? hasNext;
  bool? hasPrev;

  Pagination({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasNext,
    this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["totalPages"],
    hasNext: json["hasNext"],
    hasPrev: json["hasPrev"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPages": totalPages,
    "hasNext": hasNext,
    "hasPrev": hasPrev,
  };
}

class Product {
  String? id;
  String? name;
  String? slug;
  String? description;
  String? shortDescription;
  List<dynamic>? aboutDescription;
  String? categoryId;
  Category? category;
  String? subCategoryId;
  Category? subCategory;
  String? brandId;
  List<String>? categories;
  String? status;
  Seller? seller;
  String? barcode;
  List<Variant>? variants;
  VariantSummary? variantSummary;
  List<VariantAttribute>? variantAttributes;
  int? averageRating;
  int? reviewCount;
  RatingSummary? ratingSummary;
  int? soldCount;
  int? viewCount;
  SellerId? sellerId;
  AtedBy? createdBy;
  AtedBy? updatedBy;
  bool? isTaxable;
  bool? isShippable;
  bool? isVisible;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? bestSellersRank;
  bool? isDeleted;
  int? totalUnitsSold;
  bool? isWished;

  Product({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.shortDescription,
    this.aboutDescription,
    this.categoryId,
    this.category,
    this.subCategoryId,
    this.subCategory,
    this.brandId,
    this.categories,
    this.status,
    this.seller,
    this.barcode,
    this.variants,
    this.variantSummary,
    this.variantAttributes,
    this.averageRating,
    this.reviewCount,
    this.ratingSummary,
    this.soldCount,
    this.viewCount,
    this.sellerId,
    this.createdBy,
    this.updatedBy,
    this.isTaxable,
    this.isShippable,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
    this.bestSellersRank,
    this.isDeleted,
    this.totalUnitsSold,
    this.isWished,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    shortDescription: json["shortDescription"],
    aboutDescription: json["aboutDescription"] == null
        ? []
        : List<dynamic>.from(json["aboutDescription"]!.map((x) => x)),
    categoryId: json["categoryId"],
    category: json["category"] == null
        ? null
        : Category.fromJson(json["category"]),
    subCategoryId: json["subCategoryId"],
    subCategory: json["subCategory"] == null
        ? null
        : Category.fromJson(json["subCategory"]),
    brandId: json["brandId"],
    categories: json["categories"] == null
        ? []
        : List<String>.from(json["categories"]!.map((x) => x)),
    status: json["status"],
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
    barcode: json["barcode"],
    variants: json["variants"] == null
        ? []
        : List<Variant>.from(json["variants"]!.map((x) => Variant.fromJson(x))),
    variantSummary: json["variantSummary"] == null
        ? null
        : VariantSummary.fromJson(json["variantSummary"]),
    variantAttributes: json["variantAttributes"] == null
        ? []
        : List<VariantAttribute>.from(
            json["variantAttributes"]!.map((x) => VariantAttribute.fromJson(x)),
          ),
    averageRating: (json["averageRating"] as num?)?.toInt(),
    reviewCount: json["reviewCount"],
    ratingSummary: json["ratingSummary"] == null
        ? null
        : RatingSummary.fromJson(json["ratingSummary"]),
    soldCount: json["soldCount"],
    viewCount: json["viewCount"],
    sellerId: sellerIdValues.map[json["sellerId"]],
    createdBy: json["createdBy"] == null
        ? null
        : AtedBy.fromJson(json["createdBy"]),
    updatedBy: json["updatedBy"] == null
        ? null
        : AtedBy.fromJson(json["updatedBy"]),
    isTaxable: json["isTaxable"],
    isShippable: json["isShippable"],
    isVisible: json["isVisible"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    bestSellersRank: json["bestSellersRank"],
    isDeleted: json["isDeleted"],
    totalUnitsSold: json["totalUnitsSold"],
    isWished: json["isWished"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "shortDescription": shortDescription,
    "aboutDescription": aboutDescription == null
        ? []
        : List<dynamic>.from(aboutDescription!.map((x) => x)),
    "categoryId": categoryId,
    "category": category?.toJson(),
    "subCategoryId": subCategoryId,
    "subCategory": subCategory?.toJson(),
    "brandId": brandId,
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x)),
    "status": status,
    "seller": seller?.toJson(),
    "barcode": barcode,
    "variants": variants == null
        ? []
        : List<dynamic>.from(variants!.map((x) => x.toJson())),
    "variantSummary": variantSummary?.toJson(),
    "variantAttributes": variantAttributes == null
        ? []
        : List<dynamic>.from(variantAttributes!.map((x) => x.toJson())),
    "averageRating": averageRating,
    "reviewCount": reviewCount,
    "ratingSummary": ratingSummary?.toJson(),
    "soldCount": soldCount,
    "viewCount": viewCount,
    "sellerId": sellerIdValues.reverse[sellerId],
    "createdBy": createdBy?.toJson(),
    "updatedBy": updatedBy?.toJson(),
    "isTaxable": isTaxable,
    "isShippable": isShippable,
    "isVisible": isVisible,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "bestSellersRank": bestSellersRank,
    "isDeleted": isDeleted,
    "totalUnitsSold": totalUnitsSold,
    "isWished": isWished,
  };
}

class Category {
  String? id;
  String? name;
  String? slug;

  Category({this.id, this.name, this.slug});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["_id"], name: json["name"], slug: json["slug"]);

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "slug": slug};
}

class AtedBy {
  SellerId? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? profileImage;
  String? coverImage;
  List<Role>? roles;
  String? bio;
  int? followersCount;
  int? followingCount;

  AtedBy({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImage,
    this.coverImage,
    this.roles,
    this.bio,
    this.followersCount,
    this.followingCount,
  });

  factory AtedBy.fromJson(Map<String, dynamic> json) => AtedBy(
    id: sellerIdValues.map[json["_id"]],
    username: json["username"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    profileImage: json["profileImage"],
    coverImage: json["coverImage"],
    roles: json["roles"] == null
        ? []
        : List<Role>.from(
            (json["roles"] as List)
                .map((x) => roleValues.map[x])
                .whereType<Role>(),
          ),
    bio: json["bio"],
    followersCount: json["followersCount"],
    followingCount: json["followingCount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": sellerIdValues.reverse[id],
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "profileImage": profileImage,
    "coverImage": coverImage,
    "roles": roles == null
        ? []
        : List<dynamic>.from(roles!.map((x) => roleValues.reverse[x])),
    "bio": bio,
    "followersCount": followersCount,
    "followingCount": followingCount,
  };
}

enum SellerId {
  THE_6931227_F7875_D45403_DE7024,
  THE_693155_BB0_C50_F337_D7_D5_B78_B,
  THE_693_AAB41_DDC466_FAFAB35430,
}

final sellerIdValues = EnumValues({
  "6931227f7875d45403de7024": SellerId.THE_6931227_F7875_D45403_DE7024,
  "693155bb0c50f337d7d5b78b": SellerId.THE_693155_BB0_C50_F337_D7_D5_B78_B,
  "693aab41ddc466fafab35430": SellerId.THE_693_AAB41_DDC466_FAFAB35430,
});

enum Role { USER }

final roleValues = EnumValues({"user": Role.USER});

class RatingSummary {
  int? totalReviews;
  num? averageRating;
  Breakdown? breakdown;

  RatingSummary({this.totalReviews, this.averageRating, this.breakdown});

  factory RatingSummary.fromJson(Map<String, dynamic> json) => RatingSummary(
    totalReviews: json["totalReviews"],
    averageRating: json["averageRating"] as num?,
    breakdown: json["breakdown"] == null
        ? null
        : Breakdown.fromJson(json["breakdown"]),
  );

  Map<String, dynamic> toJson() => {
    "totalReviews": totalReviews,
    "averageRating": averageRating,
    "breakdown": breakdown?.toJson(),
  };
}

class Breakdown {
  int? oneStar;
  int? twoStar;
  int? threeStar;
  int? fourStar;
  int? fiveStar;

  Breakdown({
    this.oneStar,
    this.twoStar,
    this.threeStar,
    this.fourStar,
    this.fiveStar,
  });

  factory Breakdown.fromJson(Map<String, dynamic> json) => Breakdown(
    oneStar: json["oneStar"],
    twoStar: json["twoStar"],
    threeStar: json["threeStar"],
    fourStar: json["fourStar"],
    fiveStar: json["fiveStar"],
  );

  Map<String, dynamic> toJson() => {
    "oneStar": oneStar,
    "twoStar": twoStar,
    "threeStar": threeStar,
    "fourStar": fourStar,
    "fiveStar": fiveStar,
  };
}

class Seller {
  SellerId? id;
  String? email;
  String? username;
  String? firstName;
  String? lastName;
  String? bio;
  List<dynamic>? roles;
  String? avatar;

  Seller({
    this.id,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.bio,
    this.roles,
    this.avatar,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    id: sellerIdValues.map[json["_id"]],
    email: json["email"],
    username: json["username"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    bio: json["bio"],
    roles: json["roles"] == null
        ? []
        : List<dynamic>.from(json["roles"]!.map((x) => x)),
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "_id": sellerIdValues.reverse[id],
    "email": email,
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "bio": bio,
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
    "avatar": avatar,
  };
}

class VariantAttribute {
  String? attributeId;
  String? attributeName;
  String? attributeSlug;
  List<Value>? values;

  VariantAttribute({
    this.attributeId,
    this.attributeName,
    this.attributeSlug,
    this.values,
  });

  factory VariantAttribute.fromJson(Map<String, dynamic> json) =>
      VariantAttribute(
        attributeId: json["attributeId"],
        attributeName: json["attributeName"],
        attributeSlug: json["attributeSlug"],
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "attributeId": attributeId,
    "attributeName": attributeName,
    "attributeSlug": attributeSlug,
    "values": values == null
        ? []
        : List<dynamic>.from(values!.map((x) => x.toJson())),
  };
}

class Value {
  String? valueId;
  String? value;
  String? displayValue;

  Value({this.valueId, this.value, this.displayValue});

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    valueId: json["valueId"],
    value: json["value"],
    displayValue: json["displayValue"],
  );

  Map<String, dynamic> toJson() => {
    "valueId": valueId,
    "value": value,
    "displayValue": displayValue,
  };
}

class VariantSummary {
  int? totalVariants;
  int? totalStock;
  PriceRange? priceRange;
  List<AvailableColor>? availableColors;
  List<AvailableColor>? availableSizes;
  List<dynamic>? availableMaterials;
  bool? hasVariants;
  Variant? defaultVariant;

  VariantSummary({
    this.totalVariants,
    this.totalStock,
    this.priceRange,
    this.availableColors,
    this.availableSizes,
    this.availableMaterials,
    this.hasVariants,
    this.defaultVariant,
  });

  factory VariantSummary.fromJson(Map<String, dynamic> json) => VariantSummary(
    totalVariants: json["totalVariants"],
    totalStock: json["totalStock"],
    priceRange: json["priceRange"] == null
        ? null
        : PriceRange.fromJson(json["priceRange"]),
    availableColors: json["availableColors"] == null
        ? []
        : List<AvailableColor>.from(
            json["availableColors"]!.map((x) => AvailableColor.fromJson(x)),
          ),
    availableSizes: json["availableSizes"] == null
        ? []
        : List<AvailableColor>.from(
            json["availableSizes"]!.map((x) => AvailableColor.fromJson(x)),
          ),
    availableMaterials: json["availableMaterials"] == null
        ? []
        : List<dynamic>.from(json["availableMaterials"]!.map((x) => x)),
    hasVariants: json["hasVariants"],
    defaultVariant: json["defaultVariant"] == null
        ? null
        : Variant.fromJson(json["defaultVariant"]),
  );

  Map<String, dynamic> toJson() => {
    "totalVariants": totalVariants,
    "totalStock": totalStock,
    "priceRange": priceRange?.toJson(),
    "availableColors": availableColors == null
        ? []
        : List<dynamic>.from(availableColors!.map((x) => x.toJson())),
    "availableSizes": availableSizes == null
        ? []
        : List<dynamic>.from(availableSizes!.map((x) => x.toJson())),
    "availableMaterials": availableMaterials == null
        ? []
        : List<dynamic>.from(availableMaterials!.map((x) => x)),
    "hasVariants": hasVariants,
    "defaultVariant": defaultVariant?.toJson(),
  };
}

class AvailableColor {
  String? id;
  String? name;
  String? value;

  AvailableColor({this.id, this.name, this.value});

  factory AvailableColor.fromJson(Map<String, dynamic> json) =>
      AvailableColor(id: json["_id"], name: json["name"], value: json["value"]);

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "value": value};
}

class Variant {
  String? id;
  String? variantId;
  String? productId;
  String? brandId;
  Brand? brand;
  num? price;
  num? mrp;
  int? stock;
  String? sku;
  String? barcode;
  String? status;
  bool? trackInventory;
  bool? allowBackorders;
  List<Image>? images;
  int? soldCount;
  int? viewCount;
  bool? isDefault;
  int? sortOrder;
  DateTime? saleStartDate;
  DateTime? saleEndDate;
  int? saleDiscountPercentage;
  bool? isOnSale;
  AtedBy? createdBy;
  AtedBy? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Attribute>? attributes;
  String? variantName;
  List<Specification>? specifications;
  int? minStock;
  int? maxStock;
  AvailableColor? color;
  AvailableColor? size;

  Variant({
    this.id,
    this.variantId,
    this.productId,
    this.brandId,
    this.brand,
    this.price,
    this.mrp,
    this.stock,
    this.sku,
    this.barcode,
    this.status,
    this.trackInventory,
    this.allowBackorders,
    this.images,
    this.soldCount,
    this.viewCount,
    this.isDefault,
    this.sortOrder,
    this.saleStartDate,
    this.saleEndDate,
    this.saleDiscountPercentage,
    this.isOnSale,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.attributes,
    this.variantName,
    this.specifications,
    this.minStock,
    this.maxStock,
    this.color,
    this.size,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["_id"],
    variantId: json["variantId"],
    productId: json["productId"],
    brandId: json["brandId"],
    brand: json["brand"] == null ? null : Brand.fromJson(json["brand"]),
    price: json["price"] as num?,
    mrp: json["mrp"] as num?,
    stock: json["stock"],
    sku: json["sku"],
    barcode: json["barcode"],
    status: json["status"],
    trackInventory: json["trackInventory"],
    allowBackorders: json["allowBackorders"],
    images: json["images"] == null
        ? []
        : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
    soldCount: json["soldCount"],
    viewCount: json["viewCount"],
    isDefault: json["isDefault"],
    sortOrder: json["sortOrder"],
    saleStartDate: json["saleStartDate"] == null
        ? null
        : DateTime.parse(json["saleStartDate"]),
    saleEndDate: json["saleEndDate"] == null
        ? null
        : DateTime.parse(json["saleEndDate"]),
    saleDiscountPercentage: json["saleDiscountPercentage"],
    isOnSale: json["isOnSale"],
    createdBy: json["createdBy"] == null
        ? null
        : AtedBy.fromJson(json["createdBy"]),
    updatedBy: json["updatedBy"] == null
        ? null
        : AtedBy.fromJson(json["updatedBy"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    attributes: json["attributes"] == null
        ? []
        : List<Attribute>.from(
            json["attributes"]!.map((x) => Attribute.fromJson(x)),
          ),
    variantName: json["variantName"],
    specifications: json["specifications"] == null
        ? []
        : List<Specification>.from(
            json["specifications"]!.map((x) => Specification.fromJson(x)),
          ),
    minStock: json["minStock"],
    maxStock: json["maxStock"],
    color: json["color"] == null
        ? null
        : AvailableColor.fromJson(json["color"]),
    size: json["size"] == null ? null : AvailableColor.fromJson(json["size"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "variantId": variantId,
    "productId": productId,
    "brandId": brandId,
    "brand": brand?.toJson(),
    "price": price,
    "mrp": mrp,
    "stock": stock,
    "sku": sku,
    "barcode": barcode,
    "status": status,
    "trackInventory": trackInventory,
    "allowBackorders": allowBackorders,
    "images": images == null
        ? []
        : List<dynamic>.from(images!.map((x) => x.toJson())),
    "soldCount": soldCount,
    "viewCount": viewCount,
    "isDefault": isDefault,
    "sortOrder": sortOrder,
    "saleStartDate": saleStartDate?.toIso8601String(),
    "saleEndDate": saleEndDate?.toIso8601String(),
    "saleDiscountPercentage": saleDiscountPercentage,
    "isOnSale": isOnSale,
    "createdBy": createdBy?.toJson(),
    "updatedBy": updatedBy?.toJson(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "attributes": attributes == null
        ? []
        : List<dynamic>.from(attributes!.map((x) => x.toJson())),
    "variantName": variantName,
    "specifications": specifications == null
        ? []
        : List<dynamic>.from(specifications!.map((x) => x.toJson())),
    "minStock": minStock,
    "maxStock": maxStock,
    "color": color?.toJson(),
    "size": size?.toJson(),
  };
}

class Attribute {
  String? attributeId;
  String? attributeName;
  String? attributeSlug;
  String? valueId;
  String? value;
  String? displayValue;

  Attribute({
    this.attributeId,
    this.attributeName,
    this.attributeSlug,
    this.valueId,
    this.value,
    this.displayValue,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    attributeId: json["attributeId"],
    attributeName: json["attributeName"],
    attributeSlug: json["attributeSlug"],
    valueId: json["valueId"],
    value: json["value"],
    displayValue: json["displayValue"],
  );

  Map<String, dynamic> toJson() => {
    "attributeId": attributeId,
    "attributeName": attributeName,
    "attributeSlug": attributeSlug,
    "valueId": valueId,
    "value": value,
    "displayValue": displayValue,
  };
}

class Brand {
  String? id;
  String? brandName;
  String? brandSlug;
  bool? isTrending;
  bool? isPopular;

  Brand({
    this.id,
    this.brandName,
    this.brandSlug,
    this.isTrending,
    this.isPopular,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["_id"],
    brandName: json["brandName"],
    brandSlug: json["brandSlug"],
    isTrending: json["isTrending"],
    isPopular: json["isPopular"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "brandName": brandName,
    "brandSlug": brandSlug,
    "isTrending": isTrending,
    "isPopular": isPopular,
  };
}

class Image {
  String? url;
  String? filename;
  String? originalName;
  String? alt;
  bool? isPrimary;
  int? order;
  int? size;
  Mimetype? mimetype;

  Image({
    this.url,
    this.filename,
    this.originalName,
    this.alt,
    this.isPrimary,
    this.order,
    this.size,
    this.mimetype,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    url: json["url"],
    filename: json["filename"],
    originalName: json["originalName"],
    alt: json["alt"],
    isPrimary: json["isPrimary"],
    order: json["order"],
    size: json["size"],
    mimetype: mimetypeValues.map[json["mimetype"]],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "filename": filename,
    "originalName": originalName,
    "alt": alt,
    "isPrimary": isPrimary,
    "order": order,
    "size": size,
    "mimetype": mimetypeValues.reverse[mimetype],
  };
}

enum Mimetype { IMAGE_PNG }

final mimetypeValues = EnumValues({"image/png": Mimetype.IMAGE_PNG});

class Specification {
  String? key;
  String? value;

  Specification({this.key, this.value});

  factory Specification.fromJson(Map<String, dynamic> json) =>
      Specification(key: json["key"], value: json["value"]);

  Map<String, dynamic> toJson() => {"key": key, "value": value};
}

class PriceRange {
  num? min;
  num? max;

  PriceRange({this.min, this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) =>
      PriceRange(min: json["min"] as num?, max: json["max"] as num?);

  Map<String, dynamic> toJson() => {"min": min, "max": max};
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
