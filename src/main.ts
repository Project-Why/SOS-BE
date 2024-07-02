import { INestApplication, Logger, ValidationPipe } from '@nestjs/common'
import { NestFactory } from '@nestjs/core'

import { AppModule } from './app.module'
import { HttpExceptionFilter } from './middleware/exception-filter.middleware'

const logger = new Logger()

async function bootstrap() {
  const app: INestApplication = await NestFactory.create(AppModule)
  app.useGlobalFilters(new HttpExceptionFilter())
  app.useGlobalPipes(new ValidationPipe())
  await app.listen(process.env.PORT)
}

if (isNaN(parseInt(process.env.PORT))) {
  logger.error('No port provided.')
  process.exit(666)
}

bootstrap().then(() => logger.log(`Service listening: ${process.env.PORT}`))
