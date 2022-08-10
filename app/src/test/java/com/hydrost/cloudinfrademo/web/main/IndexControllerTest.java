package com.hydrost.cloudinfrademo.web.main;

import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.time.Instant;

import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.hamcrest.TypeSafeMatcher;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

@WebMvcTest(IndexController.class)
public class IndexControllerTest {

    /**
     * Represents the tolerance (in milliseconds) that is acceptable between a generated timestamp and the time the
     * test is initiated. We cannot compare to the "current time" because there will always be time between
     * when a test is started and when any other calls complete.
     * 
     * In a real world scenario, this would most likely be set via a system property / CLI option. Something
     * configurable based on the environment...
     */
    private static final Long TIMESTAMP_TOLERANCE = 300L;
    
    @Autowired
    MockMvc mockMvc;

    @Test
    public void indexRespondsWithExpectedMessage_success() throws Exception {
        Long testTime = Instant.now().toEpochMilli();

        mockMvc
            .perform(
                MockMvcRequestBuilders
                    .get("/")
            )
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json"))
            .andExpect(jsonPath("$.message", is("Automate all the things!")))
            .andExpect(jsonPath("$.timestamp", is(greaterThan(testTime)))) // Even though we're going to make sure the time is within a tolerance, we want to ensure it's after, as well.
            .andExpect(jsonPath("$.timestamp", is(IsWithinTolerance.isWithinTolerance(TIMESTAMP_TOLERANCE, testTime))))
            ;
    }


    /**
     * Custom matcher to ensure a generated, non-deterministic Long value (e.g. timestamp) is within an acceptable range.
     * 
     * This could have been made to ensure "greater than and within tolerance", but this implementation is more generic and can
     * be combined with the existing isGreaterThan matcher or any other.
     */
    private static class IsWithinTolerance extends TypeSafeMatcher<Long> {
        private Long tolerance;
        private Long testTime;

        private IsWithinTolerance(Long tolerance, Long testTime) {
            if (tolerance == null) {
                throw new IllegalArgumentException("Tolerance must be a non-null, Long value.");
            }

            if (testTime == null) {
                throw new IllegalArgumentException("Comparison value must be a non-null, Long value.");
            }

            this.tolerance = tolerance;
            this.testTime = testTime;
        }

        public static Matcher<Long> isWithinTolerance(Long tolerance, Long testTime) {
            return new IsWithinTolerance(tolerance, testTime);
        }

        @Override
        public boolean matchesSafely(Long value) {
          return value != null && ( value < testTime + tolerance ) && ( value > testTime - tolerance );
        }

        @Override
        public void describeTo(Description mismatchDescription) {
          mismatchDescription.appendText("not between " + ( testTime - tolerance ) + " and " + (testTime + tolerance) + " (tolerance of " + tolerance + ")");
        }
      };
}
