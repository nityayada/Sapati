<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List, com.sapati.model.Category, com.sapati.dao.CategoryDAO" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Initiate Listing | Sapati.com</title>

            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800;900&display=swap"
                rel="stylesheet">
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
                rel="stylesheet" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/landing.css">
            <style>
                /* Photo Upload Section Styles to match Image 02 */
                .upload-container {
                    display: flex;
                    flex-direction: column;
                    gap: 1.5rem;
                    margin-top: 1rem;
                }

                .upload-drop-zone {
                    border: 2px dashed var(--outline-variant);
                    padding: 3rem;
                    text-align: center;
                    cursor: pointer;
                    transition: all 0.2s ease;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    background-color: var(--surface-container-low);
                    border-radius: 0.5rem;
                }

                .upload-drop-zone:hover {
                    background-color: var(--surface-variant);
                    border-color: var(--primary);
                }

                .upload-icon {
                    font-size: 2.5rem;
                    color: var(--outline);
                    margin-bottom: 0.75rem;
                }

                .upload-text {
                    font-size: 0.75rem;
                    font-weight: 900;
                    letter-spacing: 0.05em;
                    color: var(--primary);
                    text-transform: uppercase;
                }

                .separator-container {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    width: 100%;
                    margin: 0.5rem 0;
                }

                .separator-line {
                    flex: 1;
                    height: 1px;
                    background-color: var(--outline-variant);
                    opacity: 0.3;
                }

                .separator-text {
                    font-size: 0.7rem;
                    font-weight: 900;
                    color: var(--outline);
                    letter-spacing: 0.1em;
                }

                .url-input-wrapper {
                    position: relative;
                }

                .url-input {
                    padding-right: 3rem !important;
                    background-color: var(--surface-container-low);
                    font-size: 0.8125rem !important;
                    font-weight: 700;
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                }

                .url-icon {
                    position: absolute;
                    right: 1rem;
                    top: 50%;
                    transform: translateY(-50%);
                    font-size: 1.25rem;
                    color: var(--outline);
                    pointer-events: none;
                }

                #file-name-display {
                    font-size: 0.7rem;
                    color: var(--primary);
                    margin-top: 0.5rem;
                    font-weight: 700;
                }
            </style>
        </head>

        <body style="background-color: var(--surface);">

            <jsp:include page="components/member_header.jsp" />

            <main class="container">
                <div class="editorial-grid" style="grid-template-columns: 1fr 1fr; gap: 6rem; padding: 6rem 0;">

                    <!-- Left: Curated Instruction -->
                    <section>
                        <span class="label-md" style="color: var(--outline); margin-bottom: 2rem; display: block;">STEP
                            01: RESOURCE REGISTRATION</span>
                        <h1
                            style="font-size: 5rem; font-weight: 900; line-height: 0.85; text-transform: uppercase; margin-bottom: 3rem; letter-spacing: -0.06em;">
                            Share your <br><span style="color: var(--primary);">surplus.</span>
                        </h1>
                        <p
                            style="font-size: 1.125rem; line-height: 1.6; color: var(--on-surface-variant); max-width: 480px;">
                            By listing your items, you help build a local economy of trust. Every resource shared
                            reduces community waste and strengthens neighborly bonds.
                        </p>

                        <div style="margin-top: 4rem; border-top: 1px solid var(--outline-variant); padding-top: 3rem;">
                            <div style="display: flex; gap: 2rem; margin-bottom: 2rem;">
                                <div class="material-symbols-outlined" style="font-size: 2rem; color: var(--primary);">
                                    verified_user</div>
                                <div>
                                    <div style="font-weight: 900; text-transform: uppercase; font-size: 0.875rem;">
                                        Verified Node</div>
                                    <div style="font-size: 0.75rem; opacity: 0.6;">Your listing will be linked to your
                                        verified home address.</div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Right: Registration Form -->
                    <section class="auth-card"
                        style="padding: 4rem; border: 1px solid var(--outline-variant); background-color: white;">
                        <% if (request.getAttribute("error") !=null) { %>
                            <div class="auth-msg auth-msg-error" style="margin-bottom: 2rem;">
                                <%= request.getAttribute("error") %>
                            </div>
                            <% } %>

                                <form action="<%= request.getContextPath() %>/item" method="POST" class="space-y-12"
                                    enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="add">

                                    <div class="form-group">
                                        <label class="label-md" style="color: var(--outline);">RESOURCE NAME</label>
                                        <input type="text" name="name" class="form-input" required
                                            placeholder="e.g. DEWALT POWER DRILL"
                                            style="text-transform: uppercase; font-weight: 900; letter-spacing: 0.05em;">
                                    </div>

                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
                                        <div class="form-group">
                                            <label class="label-md" style="color: var(--outline);">CATEGORY</label>
                                            <select name="category_id" class="form-input" required
                                                style="font-weight: 700;">
                                                <% CategoryDAO catDAO=new CategoryDAO(); List<Category> categories =
                                                    catDAO.getAllCategories();
                                                    for (Category cat : categories) {
                                                    %>
                                                    <option value="<%= cat.getCategoryId() %>">
                                                        <%= cat.getCategoryName().toUpperCase() %>
                                                    </option>
                                                    <% } %>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="label-md" style="color: var(--outline);">CONDITION</label>
                                            <input type="text" name="condition" class="form-input" required
                                                placeholder="e.g. LIKE NEW" style="font-weight: 700;">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="label-md" style="color: var(--outline);">TECHNICAL
                                            SPECIFICATIONS</label>
                                        <textarea name="description" class="form-input" rows="4" required
                                            placeholder="PROVIDE CLEAR DETAILS FOR BORROWERS..."
                                            style="font-family: inherit;"></textarea>
                                    </div>

                                    <div class="form-group">
                                        <label class="label-md" style="color: var(--outline);">RESOURCE PHOTO</label>
                                        <div class="upload-container">
                                            <!-- Local Upload Area -->
                                            <div class="upload-drop-zone"
                                                onclick="document.getElementById('file-upload').click();">
                                                <span class="material-symbols-outlined upload-icon">upload_file</span>
                                                <span class="upload-text">LOCAL UPLOAD</span>
                                                <input type="file" id="file-upload" name="image" accept="image/*"
                                                    style="display: none;" onchange="updateFileName(this)">
                                                <p id="file-name-display" style="display: none;"></p>
                                            </div>

                                            <!-- Separator -->
                                            <div class="separator-container">
                                                <div class="separator-line"></div>
                                                <span class="separator-text">— OR —</span>
                                                <div class="separator-line"></div>
                                            </div>

                                            <!-- External Reference Area -->
                                            <div class="url-input-wrapper">
                                                <input type="text" name="image_url" class="form-input url-input"
                                                    placeholder="EXTERNAL REFERENCE URL">
                                                <span class="material-symbols-outlined url-icon">link</span>
                                            </div>
                                        </div>
                                    </div>
                                    <script>
                                        function updateFileName(input) {
                                            const display = document.getElementById('file-name-display');
                                            if (input.files && input.files[0]) {
                                                display.textContent = "SELECTED: " + input.files[0].name.toUpperCase();
                                                display.style.display = 'block';
                                                // Change zone style to indicate success
                                                document.querySelector('.upload-drop-zone').style.borderColor = 'var(--primary)';
                                            } else {
                                                display.style.display = 'none';
                                                document.querySelector('.upload-drop-zone').style.borderColor = 'var(--outline-variant)';
                                            }
                                        }
                                    </script>

                                    <button type="submit" class="btn btn-primary"
                                        style="width: 100%; padding: 1.5rem; font-size: 0.8125rem; letter-spacing: 0.3em; margin-top: 2rem;">
                                        SUBMIT TO LEDGER
                                    </button>
                                </form>
                    </section>
                </div>
            </main>

            <jsp:include page="components/member_footer.jsp" />

        </body>

        </html>