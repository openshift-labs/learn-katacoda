// camel-k: language=java
package test;

import org.apache.camel.BindToRegistry;
import org.apache.camel.PropertyInject;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSCredentialsProvider;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;

public class MinioCustomizer {

    @BindToRegistry
    public static AmazonS3 minioClient(
            @PropertyInject("minio.endpoint") String endpointAddress,
            @PropertyInject("minio.access-key") String accessKey,
            @PropertyInject("minio.secret-key") String secretKey) {

        AwsClientBuilder.EndpointConfiguration endpoint = new AwsClientBuilder.EndpointConfiguration(endpointAddress, "US_EAST_1");
        AWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
        AWSCredentialsProvider credentialsProvider = new AWSStaticCredentialsProvider(credentials);

        return AmazonS3ClientBuilder
            .standard()
            .withEndpointConfiguration(endpoint)
            .withCredentials(credentialsProvider)
            .withPathStyleAccessEnabled(true)
            .build();

    }

}
