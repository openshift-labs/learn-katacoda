This tutorial uses an OpenShift web console.

1. Click on the _Console_ tab at the top right of the dashboard to display the OpenShift login dialog.

   ![Web Console Login](./cortex-certifai-notebook/assets/01-web-console-login.png)

2. For the credentials enter:

   * **Username:** ``developer``{{copy}}
   * **Password:** ``developer``{{copy}}

   and click **Log In**.

3. Use the pulldown menu at the top left to switch from _Administrator_ to _Developer_.

   ![List of Projects](./cortex-certifai-notebook/assets/01-switch-to-developer.png)

   A _Restricted Access_ warning is displayed. Don't worry, that's expected.

   ![Restricted Access](./cortex-certifai-notebook/assets/01-restricted-access.png)

4. Using the _Project_ pulldown menu, set the project to _myproject_.

   ![Switch to Default](./cortex-certifai-notebook/assets/01-switch-from-default.png)

5. A deployment object is displayed. Click inside the blue ring to bring up a status visualization.

   ![Light Blue Deploy](./cortex-certifai-notebook/assets/01-light-blue-deploy.png)

6. When the application is fully deployed, the outer ring changes to dark blue, and the pod status is displayed as _Running_.

   ![Dark Blue Deploy](./cortex-certifai-notebook/assets/01-dark-blue-with-running.png)

7. Click **Continue**.
