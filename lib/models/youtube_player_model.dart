class YoutubePlayerModel {
    YoutubePlayerModel({
        required this.kind,
        required this.etag,
        required this.nextPageToken,
        required this.regionCode,
        required this.pageInfo,
        required this.items,
    });

    final String? kind;
    final String? etag;
    final String? nextPageToken;
    final String? regionCode;
    final PageInfo? pageInfo;
    final List<Item> items;

    factory YoutubePlayerModel.fromJson(Map<String, dynamic> json){ 
        return YoutubePlayerModel(
            kind: json["kind"],
            etag: json["etag"],
            nextPageToken: json["nextPageToken"],
            regionCode: json["regionCode"],
            pageInfo: json["pageInfo"] == null ? null : PageInfo.fromJson(json["pageInfo"]),
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        );
    }

}

class Item {
    Item({
        required this.kind,
        required this.etag,
        required this.id,
        required this.snippet,
    });

    final String? kind;
    final String? etag;
    final Id? id;
    final Snippet? snippet;

    factory Item.fromJson(Map<String, dynamic> json){ 
        return Item(
            kind: json["kind"],
            etag: json["etag"],
            id: json["id"] == null ? null : Id.fromJson(json["id"]),
            snippet: json["snippet"] == null ? null : Snippet.fromJson(json["snippet"]),
        );
    }

}

class Id {
    Id({
        required this.kind,
        required this.videoId,
    });

    final String? kind;
    final String? videoId;

    factory Id.fromJson(Map<String, dynamic> json){ 
        return Id(
            kind: json["kind"],
            videoId: json["videoId"],
        );
    }

}

class Snippet {
    Snippet({
        required this.publishedAt,
        required this.channelId,
        required this.title,
        required this.description,
        required this.thumbnails,
        required this.channelTitle,
        required this.liveBroadcastContent,
        required this.publishTime,
    });

    final DateTime? publishedAt;
    final String? channelId;
    final String? title;
    final String? description;
    final Thumbnails? thumbnails;
    final String? channelTitle;
    final String? liveBroadcastContent;
    final DateTime? publishTime;

    factory Snippet.fromJson(Map<String, dynamic> json){ 
        return Snippet(
            publishedAt: DateTime.tryParse(json["publishedAt"] ?? ""),
            channelId: json["channelId"],
            title: json["title"],
            description: json["description"],
            thumbnails: json["thumbnails"] == null ? null : Thumbnails.fromJson(json["thumbnails"]),
            channelTitle: json["channelTitle"],
            liveBroadcastContent: json["liveBroadcastContent"],
            publishTime: DateTime.tryParse(json["publishTime"] ?? ""),
        );
    }

}

class Thumbnails {
    Thumbnails({
        required this.thumbnailsDefault,
        required this.medium,
        required this.high,
    });

    final Default? thumbnailsDefault;
    final Default? medium;
    final Default? high;

    factory Thumbnails.fromJson(Map<String, dynamic> json){ 
        return Thumbnails(
            thumbnailsDefault: json["default"] == null ? null : Default.fromJson(json["default"]),
            medium: json["medium"] == null ? null : Default.fromJson(json["medium"]),
            high: json["high"] == null ? null : Default.fromJson(json["high"]),
        );
    }

}

class Default {
    Default({
        required this.url,
        required this.width,
        required this.height,
    });

    final String? url;
    final int? width;
    final int? height;

    factory Default.fromJson(Map<String, dynamic> json){ 
        return Default(
            url: json["url"],
            width: json["width"],
            height: json["height"],
        );
    }

}

class PageInfo {
    PageInfo({
        required this.totalResults,
        this.resultsPerPage = 20,
    });

    final int? totalResults;
    final int? resultsPerPage;

    factory PageInfo.fromJson(Map<String, dynamic> json){ 
        return PageInfo(
            totalResults: json["totalResults"],
            resultsPerPage: json["resultsPerPage"],
        );
    }

}
