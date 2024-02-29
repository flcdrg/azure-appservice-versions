var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// get current .NET runtime version
app.MapGet("/", () => System.Runtime.InteropServices.RuntimeInformation.FrameworkDescription);

app.Run();
