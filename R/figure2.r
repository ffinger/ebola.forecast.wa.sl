##' Plots figure 2
##'
##' @return plot
##' @importFrom dplyr %>% mutate if_else filter
##' @importFrom cowplot plot_grid
##' @import ggplot2
##' @author Sebastian Funk
figure2 <- function()
{
    integer_breaks <- function(x) unique(floor(pretty(seq(0, (max(x) + 1) * 1.1))))

    ## calibration
    ff_calib <- samples_semi_mechanistic %>%
        incidence_forecast_calibration %>%
        mutate(best_model=if_else(stochasticity == "deterministic" &
                                  start_n_week_before == 0 &
                                  weeks_averaged == 1 &
                                  transmission_rate == "fixed", "yes", "no")) %>%
        mutate(best_model=factor(best_model, levels=c("yes", "no")),
               model=paste(stochasticity, start_n_week_before, weeks_averaged,
                           transmission_rate, sep="_"),
               model=factor(model))

    best_forecast_1step <- ff_conf %>%
        filter(variable=="cases") %>%
        mutate(horizon=as.integer((date-last_obs)/7),
               type=if_else(horizon < 1, "fit", "forecast")) %>%
        filter(stochasticity == "deterministic" &
               start_n_week_before == 0 &
               weeks_averaged == 1 &
               transmission_rate == "fixed",
               horizon == 1)

    p_sm_calibration <-
        ggplot(ff_calib %>% filter(best_model == "yes"),
               mapping=aes(x=horizon, y=mean, group=model, color=model)) +
        geom_line() +
        geom_point() +
        geom_line(data=ff_calib %>% filter(best_model == "no", ),
                  color="#F2BFC0") +
        geom_point(data=ff_calib %>% filter(best_model == "no"),
                   color="#F2BFC0") +
        geom_hline(yintercept=0.1, linetype="dashed") +
        geom_hline(yintercept=0.01, linetype="dashed") +
        expand_limits(y=0.35) +
        scale_x_continuous("Forecast horizon (in weeks)", breaks=integer_breaks) +
        scale_y_continuous("Calibration") +
        theme(legend.position="none") +
        scale_color_manual("", values=c("#E41A1C"))

    ## 1-week ahead
    p_forecast <- ggplot(best_forecast_1step, aes(x=date, shape=type, linetype=type)) +
        geom_ribbon(aes(ymin=`25%`, ymax=`75%`), alpha=0.5) +
        geom_ribbon(aes(ymin=`5%`, ymax=`95%`), alpha=0.25) +
        geom_line(aes(y=`50%`)) +
        geom_point(aes(y=`50%`)) +
        geom_line(data=ebola_wa %>% mutate(type="data"), aes(y=incidence), lwd=1.5) +
        scale_y_continuous("Weekly incidence") +
        scale_x_date("", date_breaks="2 months",
                     date_labels="%b %Y",
                     limits=c(as.Date(NA_character_),
                              max(ebola_wa$date)+7)) +
        scale_linetype_manual("", values=c(1, 1)) +
        scale_shape_manual("", values=c(NA, 19)) +
        guides(linetype=
                   guide_legend(
                       override.aes=
                           list(fill=c("white", "white"),
                                lwd=c(1.5, 0.75)
                                ))) +
        theme(legend.position = c(1.02, 1),
              legend.justification = c(1, 1),
              legend.title=element_blank(),
              legend.background =
                  element_rect(size=0.5, linetype="solid",
                               color="black"))

    p <- plot_grid(p_sm_calibration + theme(legend.position = "none"),
                   p_forecast, nrow=1, labels=c("A", "B"))

    return(p)
}

