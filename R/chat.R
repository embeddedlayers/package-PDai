#' OpenAI Chat API Interaction Function
#'
#' This function interacts with the OpenAI Chat API by sending a payload of messages and receiving responses.
#' It allows for the customization of the interaction through parameters such as temperature and top_p,
#' and uses the specified API key for authentication.
#'
#' @param apiKey A character string specifying the API key for OpenAI.
#' @param payload A list of message objects formatted according to the OpenAI API requirements.
#' @param temperature Numeric, controls randomness in the response generation, where higher values result in more random responses.
#' @param top_p Numeric, controls diversity of the response generation by limiting the likelihood of the alternatives considered by the model.
#' @param model Character string, specifies the OpenAI model to use for generating responses, default is "gpt-3.5-turbo".
#' @param chatID Optional character string, an identifier for the chat session, can be used to link responses with their queries.
#'
#' @return A list containing two elements: `results`, which includes the API response, and `chatID`, the session identifier if provided.
#'         If the request fails, returns a character string describing the error with the HTTP status code.
#' @importFrom httr POST add_headers content
#' @export
#' @examples
#' \dontrun{
#'   apiKey <- "your_openai_api_key_here"
#'   messages <- list(list("role" = "user", "content" = "Hello, world!"))
#'   response <- chat.openAI(apiKey = apiKey, payload = messages)
#'   print(response)
#' }
chat.openAI <- function(apiKey, payload, temperature = 1, top_p = 1, model = "gpt-3.5-turbo", chatID = NULL) {
  url <- "https://api.openai.com/v1/chat/completions"

  body <- list(
    "model" = model,
    "messages" = payload,
    "temperature" = temperature,
    "top_p" = top_p
  )

  result <- httr::POST(
    url,
    httr::add_headers(
      "Authorization" = paste("Bearer", apiKey),
      "Content-Type" = "application/json"
    ),
    body = body,
    encode = "json"
  )

  results <- list(results = httr::content(result),
                  chatID = chatID)

  if (result$status_code == 200) {
    return(results)
  } else {
    return(paste("Request failed with status", result$status_code))
  }
}

#' Upload Chat Response to Database
#'
#' This function takes a response from the OpenAI Chat API and uploads relevant information to a PostgreSQL database.
#' It extracts the chat ID, response content, model used for the response, and the timestamp of the upload, then
#' packages these into a data frame which is uploaded to a specified database table.
#'
#' @param response A list containing the response from the OpenAI Chat API.
#'                 The list structure should include `chatID`, a nested `results` list with `choices` and `model`.
#' @param con A PostgreSQL connection object created using DBI.
#'            This connection is used to upload the data.
#'
#' @return Invisible NULL; the function is used for its side effects of uploading data.
#' @export
#' @importFrom PDaiPostgres postgres.uploadData
#' @examples
#' \dontrun{
#'   # Assuming `response` is a response object from `chat.openAI` and `con` is a valid DBI connection
#'   chat.uploadResponse(response, con)
#' }
#' @seealso \code{\link[PDaiPostgres]{postgres.uploadData}}
chat.uploadResponse <- function(response,con){
  chatID <- response$chatID
  content <- response$results$choices[[1]]$message$content
  model <- response$results$model
  chatOutput <- data.frame(chatID = chatID,model = model,content = content,dt = Sys.time())
  PDaiPostgres::postgres.uploadData(con,'chat_output',chatOutput)
}
