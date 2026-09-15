
enum MerchantBrandingType {
none,
logo,
text,
}

class SDKMerchantBranding {
final MerchantBrandingType type;

// Flutter asset path, for example:
// assets/images/merchant_logo.png
final String? logo;

final String? text;

const SDKMerchantBranding._({
required this.type,
this.logo,
this.text,
});

const SDKMerchantBranding.none()
    : this._(
type: MerchantBrandingType.none,
);

const SDKMerchantBranding.logo(String logo)
    : this._(
type: MerchantBrandingType.logo,
logo: logo,
);

const SDKMerchantBranding.text(String text)
    : this._(
type: MerchantBrandingType.text,
text: text,
);

Map<String, dynamic> toMap() {
return {
"type": type.name,
"logo": logo,
"text": text,
};
}
}

