plugins {
    id 'java'
    id 'org.springframework.boot' version '2.7.18'
    id 'io.spring.dependency-management' version '1.1.3'
}


group 'alloy.language.server'
//version '1.0.0'

java {
    sourceCompatibility = "11"
}


repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter'

    implementation 'org.eclipse.lsp4j:org.eclipse.lsp4j.jsonrpc:0.21.0'
    implementation 'org.eclipse.lsp4j:org.eclipse.lsp4j:0.21.0'

    implementation 'com.fasterxml.jackson.core:jackson-databind:2.13.0'
    implementation 'com.fasterxml.jackson.core:jackson-core:2.13.0'
    implementation 'com.fasterxml.jackson.core:jackson-annotations:2.13.0'

    testImplementation 'org.springframework.boot:spring-boot-starter-test'

    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.3.2'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.3.2'
    implementation 'org.apache.commons:commons-lang3:3.12.0'
}

test {
    useJUnitPlatform()
}

targetCompatibility = JavaVersion.VERSION_11