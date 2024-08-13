class GroceryBarCodeScannerModel {
  List<GTINTestResults>? gTINTestResults;
  Summary? summary;
  APIMessage? aPIMessage;

  GroceryBarCodeScannerModel(
      {this.gTINTestResults, this.summary, this.aPIMessage});

  GroceryBarCodeScannerModel.fromJson(Map<String, dynamic> json) {
    if (json['GTINTestResults'] != null) {
      gTINTestResults = <GTINTestResults>[];
      json['GTINTestResults'].forEach((v) {
        gTINTestResults!.add( GTINTestResults.fromJson(v));
      });
    }
    summary =
        json['Summary'] != null ?  Summary.fromJson(json['Summary']) : null;
    aPIMessage = json['APIMessage'] != null
        ?  APIMessage.fromJson(json['APIMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.gTINTestResults != null) {
      data['GTINTestResults'] =
          this.gTINTestResults!.map((v) => v.toJson()).toList();
    }
    if (this.summary != null) {
      data['Summary'] = this.summary!.toJson();
    }
    if (this.aPIMessage != null) {
      data['APIMessage'] = this.aPIMessage!.toJson();
    }
    return data;
  }
}

class GTINTestResults {
  String? gTIN;
  int? certaintyValue;
  String? gCPCode;
  String? status;
  String? integrityCheck;
  int? integrityCode;
  String? gCPOwner;
  String? gS1Territory;
  String? gPCCategoryCode;
  String? gPCCategoryName;
  String? brandName;
  String? productDescription;
  String? productImageUrl;
  String? netContent;
  String? countryOfSaleCode;

  GTINTestResults(
      {this.gTIN,
      this.certaintyValue,
      this.gCPCode,
      this.status,
      this.integrityCheck,
      this.integrityCode,
      this.gCPOwner,
      this.gS1Territory,
      this.gPCCategoryCode,
      this.gPCCategoryName,
      this.brandName,
      this.productDescription,
      this.productImageUrl,
      this.netContent,
      this.countryOfSaleCode});

  GTINTestResults.fromJson(Map<String, dynamic> json) {
    gTIN = json['GTIN'];
    certaintyValue = json['CertaintyValue'];
    gCPCode = json['GCPCode'];
    status = json['Status'];
    integrityCheck = json['IntegrityCheck'];
    integrityCode = json['IntegrityCode'];
    gCPOwner = json['GCPOwner'];
    gS1Territory = json['GS1Territory'];
    gPCCategoryCode = json['GPCCategoryCode'];
    gPCCategoryName = json['GPCCategoryName'];
    brandName = json['BrandName'];
    productDescription = json['ProductDescription'];
    productImageUrl = json['ProductImageUrl'];
    netContent = json['NetContent'];
    countryOfSaleCode = json['CountryOfSaleCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['GTIN'] = this.gTIN;
    data['CertaintyValue'] = this.certaintyValue;
    data['GCPCode'] = this.gCPCode;
    data['Status'] = this.status;
    data['IntegrityCheck'] = this.integrityCheck;
    data['IntegrityCode'] = this.integrityCode;
    data['GCPOwner'] = this.gCPOwner;
    data['GS1Territory'] = this.gS1Territory;
    data['GPCCategoryCode'] = this.gPCCategoryCode;
    data['GPCCategoryName'] = this.gPCCategoryName;
    data['BrandName'] = this.brandName;
    data['ProductDescription'] = this.productDescription;
    data['ProductImageUrl'] = this.productImageUrl;
    data['NetContent'] = this.netContent;
    data['CountryOfSaleCode'] = this.countryOfSaleCode;
    return data;
  }
}

class Summary {
  int? totalGTINCount;
  int? totalGS1UKGTINS;
  int? totalGS1GlobalGTINS;
  int? totalGTINsWithoutGCPOwner;
  int? totalGTINErrorCount;
  int? processingTimeSeconds;
  int? lRCallCount;

  Summary(
      {this.totalGTINCount,
      this.totalGS1UKGTINS,
      this.totalGS1GlobalGTINS,
      this.totalGTINsWithoutGCPOwner,
      this.totalGTINErrorCount,
      this.processingTimeSeconds,
      this.lRCallCount});

  Summary.fromJson(Map<String, dynamic> json) {
    totalGTINCount = json['TotalGTINCount'];
    totalGS1UKGTINS = json['TotalGS1UKGTINS'];
    totalGS1GlobalGTINS = json['TotalGS1GlobalGTINS'];
    totalGTINsWithoutGCPOwner = json['TotalGTINsWithoutGCPOwner'];
    totalGTINErrorCount = json['TotalGTINErrorCount'];
    processingTimeSeconds = json['ProcessingTimeSeconds'];
    lRCallCount = json['LRCallCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['TotalGTINCount'] = this.totalGTINCount;
    data['TotalGS1UKGTINS'] = this.totalGS1UKGTINS;
    data['TotalGS1GlobalGTINS'] = this.totalGS1GlobalGTINS;
    data['TotalGTINsWithoutGCPOwner'] = this.totalGTINsWithoutGCPOwner;
    data['TotalGTINErrorCount'] = this.totalGTINErrorCount;
    data['ProcessingTimeSeconds'] = this.processingTimeSeconds;
    data['LRCallCount'] = this.lRCallCount;
    return data;
  }
}

class APIMessage {
  int? statusCode;
  String? message;

  APIMessage({this.statusCode, this.message});

  APIMessage.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    data['Message'] = this.message;
    return data;
  }
}
