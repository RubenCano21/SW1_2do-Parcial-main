import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // ✅ CORS para local y Render (pondrás tu dominio real aquí)
  app.enableCors({
    origin: [
      'http://localhost:5173',
      'http://127.0.0.1:5173',
      process.env.FRONTEND_URL, // Ejemplo cuando ya tengas el dominio en Render
    ],
    credentials: true,
  });

  // ✅ Prefijo global
  app.setGlobalPrefix('api');

  // ✅ Validaciones
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // ✅ Solo escuchar una vez
  const port = process.env.PORT ? Number(process.env.PORT) : 3000;
  await app.listen(port);

  console.log(`✅ Backend corriendo en el puerto ${port}`);
}
bootstrap();
