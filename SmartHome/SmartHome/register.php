<?php 
$title = "Register";
?>
<!DOCTYPE html>
<html lang="en">

<?php require('Partials/head.php')?>
<body class="bg-gradient-primary">
    <div class="container">
        <!-- Outer Row -->
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6 col-10">
                <div class="card o-hidden border-0 shadow-lg my-5">
                    <div class="card-body p-0">
                        <!-- Nested Row within Card Body -->
                        <div class="row">
                            <div class="col-md-12">
                                <div class="p-5">
                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-4">Register!</h1>
                                    </div>
                                    <form class="user" method="POST" action="prosesregister.php">
                                        <div class="form-group">
                                            <input type="username" class="form-control form-control-user" id="username" name="username" placeholder="Username" autocomplete="off">
                                        </div>
                                        <div class="form-group">
                                            <input type="password" class="form-control form-control-user" id="password" name="password" placeholder="Password" autocomplete="off">
                                        </div>
                                        <button type="submit" class="btn btn-primary btn-user btn-block">
                                            Register
                                        </button>
                                    </form>
                                    <hr>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <?php require('Partials/script.php')?>
</body>
</html>
