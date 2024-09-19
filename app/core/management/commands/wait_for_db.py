import time
from django.db.utils import OperationalError
from psycopg2 import OperationalError as Psycopg2OpError
from django.core.management.base import BaseCommand

class Command(BaseCommand):
    """Django command to pause execution until database is available"""
    
    def handle(self, *args, **options):
        self.stdout.write('Waiting for database...')
        db_up = False
        while db_up is False:
            try:
                self.check(databases=['default'])
                db_up = True
            except (Psycopg2OpError, OperationalError):
                self.stdout.write('Database unavailable, waiting 5 seconds...')
                time.sleep(5)  # Increase the wait time to 5 seconds
        
        self.stdout.write(self.style.SUCCESS('Database available!'))
