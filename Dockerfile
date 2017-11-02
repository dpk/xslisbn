FROM tautologe/saxon
RUN apt-get update && apt-get install -yy make curl && echo '#!/bin/bash' > /usr/local/bin/saxon && echo 'exec java -jar /usr/share/java/Saxon-HE.jar \"$@\"' >> /usr/local/bin/saxon && chmod +x /usr/local/bin/saxon
