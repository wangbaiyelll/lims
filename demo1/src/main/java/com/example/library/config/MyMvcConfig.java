package com.example.library.config;

import com.example.library.interceptor.LoginInterceptor;
import com.example.library.interceptor.PermissionInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.format.FormatterRegistry;
import org.springframework.format.datetime.DateFormatter;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import java.util.Date;

@Configuration
public class MyMvcConfig implements WebMvcConfigurer {

    @Autowired
    private LoginInterceptor loginInterceptor;
    
    @Autowired
    private PermissionInterceptor permissionInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns("/admin/**", "/teacher/**")
                .excludePathPatterns("/login", "/logout", "/css/**", "/js/**", "/images/**");
        
        // 添加权限拦截器
        registry.addInterceptor(permissionInterceptor)
                .addPathPatterns("/admin/**")
                .excludePathPatterns("/login", "/logout");
    }

    @Override
    public void addFormatters(FormatterRegistry registry) {
        // 使用Spring提供的DateFormatter来处理日期格式转换
        DateFormatter dateFormatter = new DateFormatter("yyyy-MM-dd");
        registry.addFormatterForFieldType(Date.class, dateFormatter);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置静态资源处理
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }
    
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("forward:/login.jsp");
    }
    
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/");
        resolver.setSuffix(".jsp");
        return resolver;
    }
}