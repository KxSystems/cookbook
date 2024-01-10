// Requires Java 11+
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import static java.time.ZoneOffset.UTC;
import static java.util.TimeZone.getTimeZone;
import static java.util.stream.Collectors.toMap;

public class WriteTzInfo {

    private static final ZonedDateTime startDate = ZonedDateTime.of(1900, 1, 1, 0, 0, 0, 0, UTC);
    private static final ZonedDateTime endDate = ZonedDateTime.of(2100, 1, 1, 0, 0, 0, 0, UTC);

    private static List<String> generateAdjustmentLines(String zoneName, ZoneId zoneId) {
        Logger.getLogger(WriteTzInfo.class.getName()).log(Level.INFO, "Processing {0}",zoneName);
        List<String> result = new ArrayList<>();
        ZoneOffset previousOffset = null;
        ZonedDateTime currentDate = startDate.withZoneSameInstant(zoneId);

        // Repeatedly increment by 1-minute, checking if the offset changes, and recording when this happens
        while (currentDate.isBefore(endDate)) {
            if (!currentDate.getOffset().equals(previousOffset)) {
                previousOffset = currentDate.getOffset();
                String timeUtcString = currentDate.withZoneSameInstant(UTC).format(DateTimeFormatter.ofPattern("yyyy.MM.dd'D'HH:mm:ss.SSS"));
                result.add(zoneName + "," + timeUtcString + "," + previousOffset.getTotalSeconds());
            }
            currentDate = currentDate.plusMinutes(1);
        }

        return result;
    }

    public static void main(String[] args) {
        System.setProperty("java.util.logging.SimpleFormatter.format", "%1$tF %1$tT %4$s %5$s%6$s%n");
        try (PrintWriter out = new PrintWriter(new FileWriter("tzinfo.csv"))) {
            out.println("timezoneID,gmtDateTime,gmtOffset");

            // Get all timezone ids by joining ZoneId (new) and TimeZone (legacy)
            // ZoneId doesn't include three-letter codes such as EST, and will convert these to a format such as -05:00
            // So we need to preserve the names that TimeZone uses
            Map<String, ZoneId> zoneIds = ZoneId.getAvailableZoneIds().stream().collect(toMap(Function.identity(), ZoneId::of));
            Arrays.stream(TimeZone.getAvailableIDs()).forEach(x -> zoneIds.merge(x, getTimeZone(x).toZoneId(), (zid, tz) -> zid));

            List<String> lines = zoneIds.entrySet().parallelStream()
                    .map(e -> generateAdjustmentLines(e.getKey(), e.getValue()))
                    .flatMap(Collection::stream)
                    .sorted()
                    .collect(Collectors.toList());

            for (String line : lines) {
                out.println(line);
            }

        } catch (IOException ex) {
            Logger.getLogger(WriteTzInfo.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
