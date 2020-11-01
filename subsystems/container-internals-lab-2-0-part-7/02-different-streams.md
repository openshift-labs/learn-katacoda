As mentioned in the previous step, there are two main types of streams. To view them, run the following command:

``yum module list | grep container-tools``{{execute}}

Notice there are two types:
1. container-tools:rhel8 - this is the fast moving stream, it's updated once every 12 weeks and generally fixes bugs by rolling to new versions
2. container-tools:1.0 - this was released with RHEL 8.0 and supported for 24 months, and receives bug fixes with back ports that keep the API and CLI interfaces stable
3. container-tools:2.0 - this was released with RHEL 8.2 and supported for 24 months, and receives bug fixes with back ports that keep the API and CLI interfaces stable
