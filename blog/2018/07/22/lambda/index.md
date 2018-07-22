---
title: Intro to Lambda using Ansible
tags: AWS, ansible, lambda, cloud, serverless
---

<a href=""><img style='float:right' alt='aws logo' width='120px' src='/static/images/aws.png'></a>

Here's a simple example of an [AWS Lambda](https://aws.amazon.com/lambda/) using [Ansible](https://www.ansible.com/) to set it up.

---

Lambda is another example of AWS's crazy none-intuitive naming convention. I highly recommend you bookmark [AWS in Plain English](https://www.expeditedssl.com/aws-in-plain-english), an excellent site that demystifies AWS's whimsical names. Name aside, Lambda is serverless way to run your code.

Serverless sounds like witchery but, like all cloud, it's simply someone else's server. One of the key concepts of AWS is that its services are often built on top of other services. An [RDS](https://aws.amazon.com/rds/) instance is, behind the scenes, built on top of an [EC2](https://aws.amazon.com/ec2/) instance. If you really want to understand AWS, learn the foundation: VPC, EC2, IAM, and ELB.

Lambda is no exception, it's a service for running your code on short lived pre-built containers. The containers are pre-built and you load your supported (Node.js, Java, C#, Python, and Go at this time) code onto them to run. Let's look at a super simple example and deploy it using Ansible.

## The code

This code returns a data structure and nothing else.

%= highlight Python => begin
    import pickle

    def my_lambda(event, context):
        '''The name of this sub must match the lambda handler, and the two 
        parameters are required.'''
        
        # Return whatever you like.
        return [ 
                 { "context_function_name": context.function_name },
                 { "event": event },
                 { "test": "one", "result": "pass" },
                 { "test": "two", "result": "pass" }
               ]
% end

Any parameters you pass go into the 'event' parameter. What is returned will end up in stdout. [Context](https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html) is a object that contains information about the instance of the lambda.

## THe playbook

### Zip the Lambda

The Lambda, be it one file or many, must be in a zip file.

    ---
    - hosts: localhost

      tasks:
        - name: archive lambda
          archive:
            path: ./lambda.py
            format: zip

### Upload the Lambda

Make the Lambda. Note the handler, it's the name of the Lambda and the function in the code that will be called. Every Lambda needs an IAM role, here I make it a variable that I can define elsewhere.

    - name: my lambda function
      lambda:
        state: present
        name: my_lambda
        zip_file: lambda.py.zip
        runtime: python2.7
        handler: lambda.my_lambda
        role: "{{ role }}"
        tags:
          'responsible party': nwatson@example.com

### Run the Lambda

This executes the Lambda passing the payload as arguments. They go into the 'events' parameter.Wait waits for the Lambda to finish. Finally we save the results with register.

    - name: Run my lambda
      execute_lambda:
        name: my_lambda
        payload:
          arg1: foo
          arg2: bar
        wait: true
      register: my_lambda

### Remove the Lambda

    - name: my lambda function
      lambda:
        state: absent
        name: my_lambda

### The results

    - debug:
        msg: "{{ my_lambda }}"

Here they are:

    PLAY [localhost] ********************************************************

    TASK [Gathering Facts] **************************************************
    ok: [localhost]

    TASK [archive lambda] ***************************************************
    changed: [localhost]

    TASK [my lambda function] ***********************************************
    changed: [localhost]

    TASK [Run my lambda] ****************************************************
    changed: [localhost]

    TASK [my lambda function] ***********************************************
    changed: [localhost]

    TASK [debug] ************************************************************
    ok: [localhost] => 
      msg:
        changed: true
        failed: false
        result:
          logs: ''
          output:
          - context_function_name: my_lambda
          - event:
              arg1: foo
              arg2: bar
          - result: pass
            test: one
          - result: pass
            test: two
          status: 200

    PLAY RECAP **************************************************************
    localhost                : ok=6    changed=4    unreachable=0    failed=0   

There's a lot more to Lambdas; I encourage you to read up on them. Also know that Lambda is not unique. Other container technologies like [Kubernetes](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/) and [Cloud Foundry](https://www.cloudfoundry.org/) can run short duration containers. You can find the the code for this post [here](https://github.com/neilhwatson/nustuff/tree/master/aws/lambda).
