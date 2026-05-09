package vn.edu.hcmuaf.fit.websharedocument.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

public class CloudinaryUtil {
    private static Cloudinary cloudinary;

    static {
        cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dwnbmfhel",
                "api_key", "344558975221341",
                "api_secret", "Xlg8BG-lk3hiIE7VyocTSQz3FHA",
                "secure", true
        ));
    }

    public static Cloudinary getCloudinary() {
        return cloudinary;
    }
}
